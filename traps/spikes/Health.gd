extends Control


var current_health = 40
onready var update_tween = $UpdateTween
onready var health_bar = $TextureProgress


func update_health(health):
	health_bar.value = health
