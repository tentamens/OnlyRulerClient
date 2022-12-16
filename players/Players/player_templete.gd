extends StaticBody2D


var HEALTH = 100
var IDEN = "TENT"
var last_hp = 100

func _physics_process(delta: float) -> void:
	if HEALTH != last_hp:
		var tent_state = {"HP" : HEALTH}
		Server.SendPlayerState(tent_state, "TENT")
		last_hp = HEALTH



func Update_Health(new_health):
	get_node("Control").update_health(new_health)
	HEALTH = new_health



