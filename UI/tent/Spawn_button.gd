extends VBoxContainer

var RANDOMER = 1




func _on_SpawnKnight_button_down():
	Rng.random(1, 1000000)
	var IDEN = Rng.num
	Server.RequestSpawnUnit(1, round(IDEN))


func _on_Spawn_Catapult_button_down():
	Server.RequestSpawnUnit(2, 1)
