extends Node


const SAVEDATA = "user://GameData.json"

var temp = ""

var GameData

func _ready():
	var file = File.new()
	file.open(SAVEDATA, File.WRITE)
	file.store_line()


func load_data():
	var file = File.new()
	file.open(SAVEDATA, File.READ)
	var content = file.get_as_text()
	var data = parse_json(content)
	GameData = data
	file.close()
	return(data)
