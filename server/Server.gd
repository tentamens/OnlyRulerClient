extends Node

var network = NetworkedMultiplayerENet.new()

var ip = "127.0.0.1"

var port = 1909

func _ready():
	print("connecting")
	ConnectToServer()

func ConnectToServer():
	network.create_client(ip, port)
	get_tree().set_network_peer(network)
	
	network.connect("connection_failed", self, "_OnConnectionFailed")
	network.connect("connection_succeeded", self, "_OnConnectionSucceeded")


func _OnConnectionFailed():
	print("Failed to connect :/")

func _OnConnectionSucceeded():
	print("Succesfully connected to game server :D ")



func FetchData(skill_name, requester):
	rpc_id(1, "Fetch_Data", skill_name, requester)

remote func ReturnData(s_data, requester):
	instance_from_id(requester).UpdateData(s_data)
