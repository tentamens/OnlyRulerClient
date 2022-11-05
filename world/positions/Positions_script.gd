extends Node2D

onready var top = $top
onready var bottom = $bottom
onready var front = $Node/front
onready var castle_wall = $Knight/castle_wall

func _physics_process(delta):
	if WorldPOS.gate == false:
		var x = WorldPOS.castle_position.x - 700
		WorldPOS.castle_position = Vector2(x,277)



func _ready():
	WorldPOS.position_1 = top.position
	WorldPOS.position_2 = bottom.position
	WorldPOS.position_3 = front.position
	WorldPOS.castle_position = castle_wall.position
