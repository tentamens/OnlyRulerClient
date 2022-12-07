extends Node2D



var IDEN

func _physics_process(delta):
	if IDEN != null:
		get_node("KinematicBody2D").IDEN = IDEN
		set_physics_process(false)
