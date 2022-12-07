extends Node2D

var last_world_state = 0

var Unit_NUMS = 0


var Player1ID
var Player2ID
var interpolation_offset:int = 100

export var Knight_Food: int
export var Knight_Money: int

export var Catapult_Food: int
export var Catapult_Money: int

onready var knight = preload("res://players/knight/Knight.tscn")
onready var archer = preload("res://players/archer/archer.tscn")
onready var catapult = preload("res://players/Catapult/CatapultPlayer.tscn")
onready var catapult_projectile = preload("res://players/Catapult/Catapult_Projectile.tscn")
onready var tent = preload("res://players/Players/PlayerTemplate.tscn")
onready var knightTemplete = preload("res://players/knight/KnightTemplete.tscn")
onready var archerTemplete = preload("res://players/archer/archer.tscn")
onready var catapultTemplete = preload("res://players/Catapult/CatapultPlayer.tscn")

var UnitlistUser = [
	preload("res://players/Catapult/CatapultPlayer.tscn"),
	preload("res://players/knight/Knight.tscn"),
	preload("res://players/Catapult/CatapultPlayer.tscn")
	]
var UnitlistEnemy = [
	preload("res://players/Catapult/CatapultPlayer.tscn"),
	preload("res://players/knight/KnightTemplete.tscn"),
	archerTemplete,
	]

var world_state_buffer = []

func _ready():
	Server.RequestSpawnTent()
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
	
	new_instance.global_position = Vector2(catapult_pos.x+65,
	catapult_pos.y-200)
	
	new_instance.launch()
	print("Spawned new projectile")


func SpawnTent(player_id, Spawn_Position):
	if get_tree().get_network_unique_id() != player_id:
		Player2ID = player_id
		var new_instance = tent.instance()
		get_node("Tents").add_child(new_instance)
		new_instance.name == str(player_id)
		new_instance.global_position = Spawn_Position
	
	if get_tree().get_network_unique_id() == player_id:
		Player1ID = player_id


func PlayerSpawnUnit(UnitID, IDEN):
	var new_instance = UnitlistUser[UnitID].instance()
	get_node("Navigation2D/MyUnits").add_child(new_instance)
	new_instance.position = Vector2(1167, 287)
	new_instance.set_name(str(IDEN))
	new_instance.IDEN = IDEN


func SpawnUnit(Player_State):
	var spawn_pos
	for Unit in Player_State[1].keys():
		if str(Unit) == "T":
			continue
		
		var UnitCreatorID = Player_State[0][Unit]["CI"] 

		if UnitCreatorID == get_tree().get_network_unique_id():
		
			var new_instance = UnitlistUser[
				Player_State[1][Unit]["U"]
				].instance()
			
			spawn_pos = Vector2(1167, 287)
			get_node("Navigation2D/MyUnits").add_child(new_instance)
			new_instance.set_name(str(Player_State[1][Unit]["IDEN"]))
			new_instance.global_position = spawn_pos
		
		else:
		
			var new_instance = UnitlistEnemy[Player_State[1][Unit]["U"]].instance()
			
			spawn_pos = Vector2(-275, 287)
			get_node("Navigation2D/Units").add_child(new_instance)
			new_instance.set_name(str(Player_State[1][Unit]["IDEN"]))
			new_instance.global_position = spawn_pos


func _physics_process(delta: float) -> void:
	var render_time = OS.get_system_time_msecs() - interpolation_offset
	if world_state_buffer.size() > 1:
		while world_state_buffer.size() > 2 and render_time > world_state_buffer[2].T:
				world_state_buffer.remove(0)
		if world_state_buffer.size() > 2:
			print(world_state_buffer.size())
			var interpolation_factor := float(
				render_time - world_state_buffer[1]["T"]) / float(world_state_buffer[2]["T"] - world_state_buffer[1]["T"])
			
			var UnitNode = get_node("Navigation2D/Units")
			
			for player in world_state_buffer[2].keys():
				
				if str(player) == "T":
					continue
				
				if not world_state_buffer[1].has(player):
					continue
				
				if UnitNode.has_node(str(world_state_buffer[1][player]["IDEN"])):
					if world_state_buffer[1][player]["CI"] != get_tree().get_network_unique_id():
						var new_position = lerp(world_state_buffer[1][player]["P"],
						 world_state_buffer[2][player]["P"], interpolation_factor)
						
						get_node("Navigation2D/Units/" + str(
							world_state_buffer[1][player]["IDEN"])
							).MovePlayer(new_position)
					
				elif get_node("Navigation2D/MyUnits").has_node(
					str(world_state_buffer[1][player]["IDEN"])):
					continue
				
				
				else:
					SpawnUnit(world_state_buffer)

func UpdateWorldState(world_state, unit_num, player_state):
	if world_state["T"] > last_world_state:
		last_world_state = world_state["T"]
		world_state_buffer.append(world_state)

