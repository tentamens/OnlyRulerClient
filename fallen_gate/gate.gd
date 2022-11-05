extends Node2D

export var HEALTH = 100

var currently_hitting = 0


func _physics_process(_delta):
	if HEALTH < 0:
		GlobalCamera.camera.shake(600, 0.5)
		WorldPOS.gate = false
		self.queue_free()
	
	GlobalWall.HEALTH = HEALTH




""" ////// RIGHT SIDE /////// """
func _on_right_side_area_entered(area):
	print("Right Side Entered")
	currently_hitting += 1


func _on_right_side_area_exited(area):
	currently_hitting -= 1



func _on_Timer_timeout():
	HEALTH -= currently_hitting
