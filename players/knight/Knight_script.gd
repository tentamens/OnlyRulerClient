extends KinematicBody2D

onready var Master = get_node(".")
onready var animation_player = get_parent().get_node("AnimationPlayer")
onready var die_ticks = get_node("Damage_Tick")
onready var crossair = get_node("target")

var all_touching = []

var click = false



var health
var SPEED


var Nav_poly = Nav.Nav_poly
var path = []
var threshold = 16
var velocity = Vector2.ZERO
var touch_pos


var damage
var Destination




var RNG = RandomNumberGenerator.new()


func _ready():
	Server.FetchData("Knight", get_instance_id())


func UpdateData(s_data):
	damage = s_data.Damage
	SPEED = s_data.Speed
	health = s_data.Health



	animation_player.play("walking")
	Destination = WorldPOS.castle_position
	Master.position = Vector2(1200, 300)
	animation_player.play("walking")
	path = Nav_poly.get_simple_path(global_position, Nav.Destionation, true)


func _physics_process(_delta):
	print("hello world")
	if click == true:
		crossair.global_position = touch_pos
	
	if path.size() > 0:
		move_to_target()




func move_to_target():
	if global_position.distance_to(path[0]) < threshold:
		path.remove(0)
	else:
		var direction = global_position.direction_to(path[0])
		velocity = direction * SPEED
		velocity = move_and_slide(velocity)






func _on_Area2D_area_entered(area):
	if area.name == "spikes":
		health -= 10
		SPEED = 50
		damage += 5
		die_ticks.start()
	
	
	if area.name == "Gate_Wall":
		animation_player.play("Attacking")
		print(area, "attacking")

func _on_knight_area_exited(area):
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
	path = Nav_poly.get_simple_path(global_position, touch_pos, false)
	Nav.the_group.erase(self)



func _on_Troup_Area_area_exited(area):
	all_touching.remove(all_touching.find(area))
