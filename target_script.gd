extends Node2D

onready var crossair = get_node("Sprite")
onready var pos_arrow_top = get_parent().get_node("Positions/Node/Position2D3")


onready var arrow = preload("res://players/archer/Arrow.tscn")

var click = false
var touch_pos







func _input(event):
	if event is InputEventScreenTouch:
		touch_pos = get_canvas_transform().affine_inverse().xform(event.position)
	if event is InputEventScreenDrag:
		touch_pos = get_canvas_transform().affine_inverse().xform(event.position)

func _physics_process(delta):
	if Nav.pressed:
		click = true
		crossair.visible
	
	if Project.shoot == true:
		var new_instance = arrow.instance()
		self.add_child(new_instance)
		new_instance.position = pos_arrow_top.position
		Project.shoot = false
	
	
	if click == true:
		crossair.global_position = touch_pos
		crossair.visible = true



func _on_Top_button_pressed():
	click  = true



func _on_Top_button_released():
	click = false
	crossair.visible = false
	if touch_pos.x < 0:
		print("further than the gate")
		Project.aiming_pos_1 = Vector2(80, 3) 
	else:
		Project.aiming_pos_1 = touch_pos
	

func move_units_down():
	crossair.global_position == touch_pos
	click = true
	crossair.visible = true

func move_units_up():
	click = false
	crossair.visible = false
	if touch_pos.x < 0 and WorldPOS.gate == true:
		touch_pos = Vector2(20, 3) 
	Nav.move_to(touch_pos)
