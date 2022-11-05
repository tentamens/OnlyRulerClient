extends KinematicBody2D

export var SPEED = 650

var move_to = Project.aiming_pos_1
var break_ = false

func _physics_process(delta):
	if break_ == true:
		return
	var direction
	
	
	if move_to.distance_to($".".global_position) > 5:
		direction = move_to - $".".global_position
		direction = direction.normalized() * SPEED
		move_and_slide(direction, Vector2())
	else:
		$Timer.start()
		break_ = true

func _on_Timer_timeout():
	self.queue_free()
