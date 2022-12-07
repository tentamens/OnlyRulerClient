extends Node2D


func MovePlayer(new_position):
	global_position = (Vector2(new_position.x / -1, new_position.y))
