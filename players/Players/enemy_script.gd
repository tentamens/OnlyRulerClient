extends Area2D


var IDEN = "TENT"



func inflict_damagee(damage):
	get_parent().get_node('.').HEALTH -= damage
