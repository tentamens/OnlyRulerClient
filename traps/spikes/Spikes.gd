extends StaticBody2D

onready var health_bar = get_node("Control")

export var health = 40
export var die_rate = 0.5

var current_hitting = 0


func _on_Area2D_area_entered(area):
	current_hitting += 1
	$Timer.start()


func _on_Timer_timeout():
	health -= die_rate * current_hitting
	if health <= 0: 
		queue_free()
	health_bar.update_health(health)

func _on_spikes_area_exited(area):
	current_hitting -= 1
	if current_hitting == 0:
		$Timer.stop()
