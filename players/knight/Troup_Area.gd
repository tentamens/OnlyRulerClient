extends Area2D

var IDEN

func inflict_damagee(inflicted_damage):
	get_parent().get_parent().get_node('.').inflict_damage(inflicted_damage)


func _update_health(damage):
	get_parent().get_parent().get_node('.').HEALTH -= damage
