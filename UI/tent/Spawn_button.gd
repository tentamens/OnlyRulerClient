extends VBoxContainer

var RANDOMER = 1

export var Knight_gold_cost: int
export var Knight_Food_cost: int







func _on_SpawnKnight_button_down():
	if Resoucres.Food > Knight_Food_cost and Resoucres.Gold > Knight_gold_cost:
		Rng.random(1, 10000000)
		var IDEN = Rng.num
		Server.RequestSpawnUnit(0, round(IDEN))
		Resoucres.Food -= Knight_Food_cost
		Resoucres.Gold -= Knight_gold_cost


func _on_Spawn_Catapult_button_down():
	Rng.random(1, 10000000)
	var IDEN = Rng.num
	Server.RequestSpawnUnit(1, round(IDEN))
