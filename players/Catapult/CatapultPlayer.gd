extends KinematicBody2D


export var Unit_ID:int
export var hit_delay:int
export var data_name:String = "Catapult"
export var ranged: bool = false
export var Projectile: PackedScene


onready var Master = self
onready var animation_player = $AnimationPlayer
onready var die_ticks = $Damage_Tick
onready var crossair = $target
onready var External = $Clients

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
	print(data_name, " AHH")
	Server.FetchData(data_name, get_instance_id(), "HI")
	get_node('Hit_timer').wait_time = hit_delay

func UpdateData(s_data):
	print(s_data)
	damage = s_data.Damage
	SPEED = s_data.Speed
	health = s_data.Health
	External.DAMAGE = round(damage)


	animation_player.play("walking")
	Destination = WorldPOS.castle_position
	animation_player.play("walking")
	navigation_agent.set_target_location(
		WorldPOS.castle_position)


func _physics_process(delta: float) -> void:
	
	move_to_target(delta)
	
	DefinePlayerState()

# Sends data to the server ab
func DefinePlayerState():
	if health == null:
		return
	elif IDEN != null:
		var player_state = {"T": OS.get_system_time_msecs(),
		"P": Master.global_position, "U": Unit_ID,
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
	pass



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
		Master.queue_free()


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
	
	if area.name == "Gate_Wall":
		animation_player.play("Attacking")



func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Fire":
		Project.main.shoot_Catapult(self.position)
		animation_player.play("Lower")
	if anim_name == "Lower":
		animation_player.play("Fire")
