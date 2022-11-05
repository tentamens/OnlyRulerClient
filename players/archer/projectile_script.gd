extends Node2D

onready var click = false
var touch_pos




func _on_Timer_timeout():
	Project.shoot = true
