extends KinematicBody2D

onready var Master = get_node(".")
onready var animation_player = get_parent().get_node("Animation")
onready var reached = false

export var SPEED = 150



var RNG = RandomNumberGenerator.new()
onready var RNG_NUM

func _ready():
	RNG.randomize()
	RNG_NUM = (RNG.randi_range( 1, 2 ))
	if RNG_NUM == 1:
		RNG_NUM = WorldPOS.position_1
	else:
		RNG_NUM = WorldPOS.position_2
	Master.position = Vector2(1200, 300)
	animation_player.play("walking")


func _physics_process(delta):
	
	var direction
	if reached == false:
		if RNG_NUM.distance_to(Master.position) > 10:
				direction = RNG_NUM - Master.position
				direction = direction.normalized() * SPEED
				move_and_slide(direction, Vector2())
		else:
			reached = true
			Master.position = WorldPOS.position_3
			Master.z_index = 5
			direction = Master.position
			animation_player.play("RESET")
