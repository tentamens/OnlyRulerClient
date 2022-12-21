extends Node2D

var last_world_state = 0

var Unit_NUMS = 0



var deleted_Unit = []
var Player1ID
var Player2ID
var interpolation_offset:int = 100


onready var catapult_projectile = preload("res://players/Catapult/Catapult_Projectile.tscn")
onready var tent = preload("res://players/Players/PlayerTemplate.tscn")

var UnitlistUser = [
	preload("res://players/knight/Knight.tscn"),
	preload("res://players/Catapult/CatapultPlayer.tscn"),
	preload("res://players/Catapult/CatapultPlayer.tscn")
	]
var UnitlistEnemy = [
	preload("res://players/knight/KnightTemplete.tscn"),
	preload("res://players/Catapult/CatapultTemplate.tscn"),
	
	]

var world_state_buffer = []

func _ready():
	Server.RequestSpawnTent()
	Project.main = self





func shoot_Catapult(catapult_pos):
	var new_instance = catapult_projectile.instance()
	get_node("Projectile").add_child(new_instance)
	
	new_instance.global_position = Vector2(catapult_pos.x+65,
	catapult_pos.y-200)
	
	new_instance.launch()
	print("Spawned new projectile")


func SpawnTent(player_id, Spawn_Position):
	if get_node("Tents").has_node("Tent"):
		return
	var new_instance = tent.instance()
	get_node("Tents").add_child(new_instance)
	new_instance.name == str(player_id)


func PlayerSpawnUnit(UnitID, IDEN):
	var new_instance = UnitlistUser[UnitID].instance()
	get_node("Navigation2D/MyUnits").add_child(new_instance)
	new_instance.position = Vector2(1167, 287)
	new_instance.set_name(str(IDEN))
	new_instance.IDEN = IDEN


func SpawnUnit(Player_State, l):
	var spawn_pos
	
	print("ello")
	for Unit in Player_State[1].keys():
		
		if str(Unit) == "T":
			continue
		
		elif deleted_Unit.has(str(Player_State[1][Unit])):
			continue
		
		elif Player_State[1][Unit]["HP"] <= 0:
			continue
		else:
			var UnitCreatorID = Player_State[1][Unit]["CI"] 

			if UnitCreatorID == get_tree().get_network_unique_id():
				print(Player_State[1][Unit]["U"])
				var new_instance = UnitlistUser[
					Player_State[1][Unit]["U"]
					].instance()
				
				spawn_pos = Vector2(1167, 287)
				get_node("Navigation2D/MyUnits").add_child(new_instance)
				new_instance.set_name(str(Player_State[1][Unit]["IDEN"]))
				new_instance.global_position = spawn_pos
			
			else:
				print(Player_State[1][Unit]["U"])
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
			var interpolation_factor := float(
				render_time - world_state_buffer[1]["T"]) / float(world_state_buffer[2]["T"] - world_state_buffer[1]["T"])
			
			var UnitNode = get_node("Navigation2D/Units")
			
			for player in world_state_buffer[2].keys():
				
				
				if str(player) == "T":
					continue
				
				if not world_state_buffer[1].has(player):
					continue
				
				if deleted_Unit.has(world_state_buffer[1][player]["IDEN"]):
					continue
				
				if UnitNode.has_node(str(world_state_buffer[1][player]["IDEN"])):
					if world_state_buffer[1][player]["CI"] != get_tree().get_network_unique_id():
						var IDEN = world_state_buffer[1][player]["IDEN"]
						var new_position = lerp(world_state_buffer[1][player]["P"],
						 world_state_buffer[2][player]["P"], interpolation_factor)
						get_node("Navigation2D/Units/" + str(IDEN)
							).MovePlayer(new_position, world_state_buffer[1][player])
					
				elif get_node("Navigation2D/MyUnits").has_node(
					str(world_state_buffer[1][player]["IDEN"])):
					continue
				
				
				else:
					if get_node("Navigation2D/MyUnits").has_node(
					str(world_state_buffer[1][player]["IDEN"])):
						continue
					
					elif UnitNode.has_node(str(world_state_buffer[1][player]["IDEN"])):
						continue
					
					print("spawning a new unit")
					SpawnUnit(world_state_buffer, "HI")

func UpdateWorldState(world_state, unit_num, player_state):
	if world_state["T"] > last_world_state:
		last_world_state = world_state["T"]
		world_state_buffer.append(world_state)


func Inflict_damage(Unit_IDE:int, damage_taken:int):
	
	var UnitNode = get_node("Navigation2D/MyUnits")
	if UnitNode.has_node(str(Unit_IDE)):
		var unit = get_node("Navigation2D/MyUnits/" + str(Unit_IDE))
		unit.health -= damage_taken
		unit.update_health()
	if get_node("Navigation2D/Units").has_node(str(Unit_IDE)):
		pass


func Erase(unit_iden):
	if get_node("Navigation2D/MyUnits").has_node(str(unit_iden)):
		get_node("Navigation2D/MyUnits/" + str(unit_iden)).queue_free()
	elif get_node("Navigation2D/Units").has_node(str(unit_iden)):
		get_node("Navigation2D/Units/" + str(unit_iden)).queue_free()
	deleted_Unit = [unit_iden]

func TentUpdate(State:Dictionary, ID:int):
	
	if ID == get_tree().get_network_unique_id():
		get_node("Tents/Tent").Update_Health(State["HP"])
		return
	
	var Tent = get_node("Tents/PlayerMain")
	
	if State["HP"] <= 0:
		Tent.queue_free()
		return
	
	Tent.HEALTH = State["HP"]
	



