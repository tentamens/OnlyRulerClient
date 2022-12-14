extends KinematicBody2D

onready var Master = self
onready var animation_player = get_node("AnimationPlayer")
onready var die_ticks = get_node("Damage_Tick")
onready var crossair = get_node("target")


var current_ani: int = 1


var all_hiting : Dictionary = {}
var all_touching = []

var click = false


var IDEN


var health = 100
var SPEED = 150



""" \\\\\\\\ SERVER VARS //////"""

var player_state


var Nav_poly = Nav.Nav_poly
var path = []
var threshold = 16
var velocity := Vector2.ZERO
var touch_pos

onready var navigation_agent : NavigationAgent2D = get_node(
	"NavigationAgent2D")


var damage
var Destination
onready var _timer: Timer = $Hit_timer



var RNG = RandomNumberGenerator.new()


func _ready():
	Server.FetchData("Knight", get_instance_id())

func UpdateData(s_data):
	damage = s_data.Damage
	SPEED = s_data.Speed
	health = s_data.Health



	animation_player.play("walking")
	Destination = WorldPOS.castle_position
	animation_player.play("walking")
	navigation_agent.set_target_location(Nav.Destionation)


func _physics_process(delta: float) -> void:
	
	move_to_target(delta)
	
	DefinePlayerState()

# Sends data to the server ab
func DefinePlayerState():
	if health == null:
		return
	elif IDEN != null:
		var player_state = {"T": OS.get_system_time_msecs(),
		"P": Master.global_position, "U": 1,
		"CI": get_tree().get_network_unique_id(), "IDEN": IDEN,
		"CA": current_ani, "HP": health}
		
		Server.SendPlayerState(player_state, IDEN)
		



func move_to_target(delta):
	if navigation_agent.is_navigation_finished():
		return
	var direction = global_position.direction_to(
		navigation_agent.get_next_location())
	var desired_velocity = direction * SPEED
	var steering = (desired_velocity - velocity) * delta * 4.0
	velocity += steering
	
	velocity = move_and_slide(velocity)
	update_animations(direction)



func update_animations(direction):
	"""	ANI 1 = WALKING LEFT
		ANI 2 = WALKING RIGHT
		ANI 3 = WALKING UP
		ANI 4 = WALKING DOWN"""
	var sprite: Sprite = get_node('Sprite')
	if direction.y < -0.6 and current_ani != 3:
		sprite.flip_h = false
		animation_player.play('walking_Up')
		current_ani = 3
	
	elif direction.y > 0.6 and current_ani != 4:
		sprite.flip_h = false
		animation_player.play('walking_down')
		current_ani = 4
	
	elif direction.x < -0.5 and current_ani != 1:
		sprite.flip_h = false
		animation_player.play('walking')
		current_ani = 1
	
	elif direction.x > 0.5 and current_ani != 2:
		animation_player.play('walking')
		sprite.flip_h = true
		current_ani = 2



func _on_knight_area_exited(area):
	if area.name == "enemy":
		if all_hiting.has(area):
			all_hiting.erase(area)
	
	if area.name == "spikes":
		SPEED = 150
		damage -= 5
		die_ticks.stop()

func _on_Damage_Tick_timeout():
	health -= damage
	$Control.update_health(health)
	if health <= 0:
		$".".queue_free()


func _on_TouchScreenButton_pressed():
	Nav.the_group.clear()
	Nav.the_group.insert(0,self)
	get_tree().get_nodes_in_group("Targeting")[0].move_units_down()
	var group_name = "Knight"
	var selected_node = self
	Nav.select_nodes(group_name, selected_node, all_touching)

func checkNearby(group_nodes, the_group):
	#Looks for all nearby troups and delets them from 'group_nodes' if they are not
	group_nodes.erase(self)
	for x in group_nodes:
		# -1 means "x" was not found
		if the_group.find(x) == -1:
			if self.position.distance_to(x.position) > 120:
				group_nodes.erase(x)
			else:
				the_group.insert(0, x)
	Nav.next_node(group_nodes, the_group)


func _on_TouchScreenButton_released():
	get_tree().get_nodes_in_group("Targeting")[0].move_units_up()


func update_Destination(touch_pos):
	navigation_agent.set_target_location(touch_pos)
	Nav.the_group.erase(self)



func _on_Troup_Area_area_exited(area):
	all_touching.remove(all_touching.find(area))




func _on_Hit_timer_timeout() -> void:
	# units[1] is the IDEN
	for units in all_hiting:
		if is_instance_valid(units):
			units.inflict_damagee(damage)


func update_health():
	get_node('Control').update_health(health)


func _on_Troup_Area_area_entered(area: Area2D) -> void:
	if area.name == "enemy":
		
		if !all_hiting.has(area):
			all_hiting = {area: [damage, area.IDEN]}
	
	if area.name == "Gate_Wall":
		animation_player.play("Attacking")
