extends KinematicBody2D


var path = []

var new_des
var x_pos
var y_pos

var threshold = 16
var velocity
var SPEED = 75


func _ready():
	new_location()


func _physics_process(delta):
	
	if path.size() > 0:
		move_to_target()


func move_to_target():
	if global_position.distance_to(path[0]) < threshold:
		path.remove(0)
	else:
		var direction = global_position.direction_to(path[0])
		velocity = direction * SPEED
		velocity = move_and_slide(velocity)


func go_somewhere_else():
	path = Nav.Background_poly.get_simple_path(global_position, Vector2(x_pos,y_pos), true)




func new_location():
	# THIS IS FOR X
	Rng.smallest = 0
	Rng.biggest = 1000
	Rng.random()
	x_pos = Rng.num
	Rng.num = 0
	
	
	Rng.smallest = 0
	Rng.biggest = 550
	Rng.random()
	y_pos = Rng.num
	Rng.num = 0

	go_somewhere_else()



func _on_Timer_timeout():
	new_location()


func _on_Area2D_area_entered(area):
	new_location()
