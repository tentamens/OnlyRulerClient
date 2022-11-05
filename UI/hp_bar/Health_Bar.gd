extends Control

var current_health = 100
onready var update_tween = $UpdateTween
onready var health_bar = $TextureProgress


func _physics_process(delta):
	if GlobalWall.HEALTH != current_health:
		current_health = GlobalWall.HEALTH
		update_tween.interpolate_property(health_bar, "value", health_bar.value, GlobalWall.HEALTH, 0.4, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
		update_tween.start()
	
	
