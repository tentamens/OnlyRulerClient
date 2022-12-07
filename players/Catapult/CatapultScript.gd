extends KinematicBody2D


onready var Master = self
onready var animation_player = get_node("AnimationPlayer")
onready var die_ticks = get_node("Damage_Tick")
onready var crossair = get_node("target")

var all_touching = []

var click = false

# This is used so it doesnt try to shoot while it's walking
var walking = false



var health
var SPEED


var Nav_poly = Nav.Nav_poly
var path = []
var threshold = 16
var velocity = Vector2.ZERO
var touch_pos
var new_pos = false

var Shoot_timer
var damage
var Destination

var dragged = false
var drag_click = false


# this var is used to count if the button was pressed twice to change the projectile destination
var double_tap = 0


var RNG = RandomNumberGenerator.new()


func _ready():
	Server.FetchData("Catapult", get_instance_id())


func UpdateData(s_data):
	
	Shoot_timer = s_data.ShootTimer
	damage = s_data.Damage
	SPEED = s_data.Speed
	health = s_data.Health

	get_node("Shoot_timer").wait_time = Shoot_timer
	animation_player.play("Walking")
	Destination = WorldPOS.castle_position
	Master.position = Vector2(1200, 300)
	path = Nav_poly.get_simple_path(global_position, Nav.Destionation, true)


func _physics_process(delta):
	
	if click == true:
		crossair.global_position = touch_pos
	
	if drag_click:
		crossair.global_position = touch_pos
	
	if path.size() > 0:
		move_to_target()
	else:
		walking = false



func move_to_target():
	
	walking = true
	
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



func _on_knight_area_exited(area):
	if area.name == "spikes":
		SPEED = 150
		damage -= 5
		die_ticks.stop()



""" deals damage to itself """
func _on_Damage_tick_timeout():
	health -= damage
	$Control.update_health(health)
	if health <= 0:
		$".".queue_free()





func _on_TouchScreenButton_pressed():
	double_tap += 1
	
	get_node("Targeting_timer").start()
	get_node("Movement_timer").start()


func new_target_des():
	pass


""" Checks all the nodes in the group to see if there are within 120
	of itself"""
func checkNearby(group_nodes, the_group):
	#Looks for all nearby troups and delets them from 'group_nodes' if they are not
	group_nodes.erase(self)
	for x in group_nodes:
		if the_group.find(x) == -1:
			if self.position.distance_to(x.position) > 120:
				group_nodes.erase(x)
			else:
				the_group.insert(0, x)
		print(the_group.find(x))
	Nav.next_node(group_nodes, the_group)





"""  Checks if it gonna be a position update or a targeting """
func _on_TouchScreenButton_released():
	print(double_tap)
	if double_tap == 2:
		get_node("Targeting_timer").stop()
		highlight_catapults()
		new_pos = true
		double_tap = 0
		return
	get_tree().get_nodes_in_group("Targeting")[0].move_units_up()




"""  Updates the path and erases itself form the group """
func update_Destination(touch_pos):
	path = Nav_poly.get_simple_path(global_position, touch_pos, false)
	Nav.the_group.erase(self)





"""  Tells all the Catapults to Highlight themselves  """
func highlight_catapults():
	for x in get_tree().get_nodes_in_group("Catapult"):
		x.show_shader()



func _on_Troup_Area_area_entered(area):
	all_touching.remove(all_touching.find(area))




func show_shader():
	get_node("Sprite").material.set('shader_param/width', 0.7)




func _on_Targeting_timer_timeout():
	print("took to long")
	double_tap = 0
	dragged = true


func _on_Shoot_timer_timeout():
	if walking == false:
		shoot()


func shoot():
	animation_player.play("Fire")
	print("fire")
	get_node("Shoot_timer").queue_free()






func _on_Movement_timer_timeout():
	if get_node("TouchScreenButton").is_pressed():
		Nav.the_group.clear()
		Nav.the_group.insert(0,self)
		get_tree().get_nodes_in_group("Targeting")[0].move_units_down()
	
		var group_name = "Knight"
		var selected_node = self
	
		Nav.select_nodes(group_name, selected_node, all_touching)


func _input(event):
	if event is InputEventScreenTouch:
		if new_pos:
			Project.catapult_target = get_canvas_transform().affine_inverse().xform(event.position)
			new_pos = false



func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Fire":
		Project.main.shoot_Catapult(self.position)
		animation_player.play("Lower")
	if anim_name == "Lower":
		animation_player.play("Fire")
