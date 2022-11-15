extends Node2D


onready var crossair = get_node("target")
onready var desitation = Nav.Destionation


onready var arrow = preload("res://players/archer/Arrow.tscn")

var click = false
var touch_pos




func _input(event):
	if event is InputEventScreenTouch:
		touch_pos = get_canvas_transform().affine_inverse().xform(event.position)
	if event is InputEventScreenDrag:
		touch_pos = get_canvas_transform().affine_inverse().xform(event.position)

func _physics_process(delta):
	
	if click == true:
		crossair.global_position = touch_pos



func _on_Ground_trops_button_down():
	print("pressed")
	click  = true
	crossair.visible = true


func _on_Ground_trops_button_up():
	click = false
	crossair.visible = false
	desitation = touch_pos
	if desitation.x < 530:
		Rng.smallest = 180
		Rng.biggest = 380
		Rng.random()
		Nav.Destionation = Vector2(550,Rng.num)
		Rng.num = 0
	else:
		Nav.Destionation = desitation
