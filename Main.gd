extends Node2D


export var Knight_Food: int
export var Knight_Money: int

export var Catapult_Food: int
export var Catapult_Money: int

onready var knight = preload("res://players/knight/Knight.tscn")
onready var archer = preload("res://players/archer/archer.tscn")
onready var catapult = preload("res://players/Catapult/CatapultPlayer.tscn")
onready var catapult_projectile = preload("res://players/Catapult/Catapult_Projectile.tscn")



func _ready():
	Project.main = self

func spawn_knight():
	if Resoucres.Food > Knight_Food and Resoucres.Money > Knight_Money:
		var new_instance = knight.instance()
		self.add_child(new_instance)
		Resoucres.Food -= Knight_Food
		Resoucres.Money -= Knight_Money


func spawn_catapult():
	if Resoucres.Food > Catapult_Food and Resoucres.Money > Catapult_Money:
		var new_instance = catapult.instance()
		self.add_child(new_instance)
		Resoucres.Food -= Catapult_Food
		Resoucres.Money -= Catapult_Money

func shoot_Catapult(catapult_pos):
	var new_instance = catapult_projectile.instance()
	get_node("Projectile").add_child(new_instance)
	new_instance.global_position = Vector2(catapult_pos.x+65, catapult_pos.y-150)
	new_instance.launch()
