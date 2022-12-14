extends Node2D

var player_ID = null
var IDEN = null

var HEALTH = 100



func MovePlayer(new_position, MyStats):
	if player_ID == null:
		player_ID = MyStats["CI"]
		IDEN = MyStats["IDEN"]
		get_node('KinematicBody2D/enemy').IDEN = IDEN
		print(MyStats["IDEN"])

	if HEALTH != MyStats["HP"]:
		HEALTH = MyStats["HP"]
		Update_HP()
	global_position = (Vector2(new_position.x / -1, new_position.y))
	



func inflict_damage(inflicted_damage):
	Server.Send_Hit_Data(player_ID, IDEN, inflicted_damage)

func Update_HP():
	if HEALTH <= 0:
		Server.Kill_Unit(IDEN)
		self.queue_free()
	
	get_node('KinematicBody2D/Control/TextureProgress').value = HEALTH
	
