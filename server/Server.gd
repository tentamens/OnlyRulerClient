extends Node

var token

var network = NetworkedMultiplayerENet.new()

var ip = "127.0.0.1"


var port = 12030


func ConnectToServer():
	print("Connecting to server")
	network.create_client(ip, port)
	get_tree().set_network_peer(network)
	
	network.connect("connection_failed", self, "_OnConnectionFailed")
	network.connect("connection_succeeded", self, "_OnConnectionSucceeded")


func _OnConnectionFailed():
	print("Failed to connect :/")

func _OnConnectionSucceeded():
	print("Succesfully connected to game server :D ")

remote func FetchToken():
	rpc_id(1, "ReturnToken", token)

func FetchData(skill_name, requester):
	rpc_id(1, "Fetch_Data", skill_name, requester)

remote func ReturnData(s_data, requester):
	instance_from_id(requester).UpdateData(s_data)


remote func ReturnTokenVerificationResults(result):
	if result == true:
		get_node("/root/Ui_background/GUI").queue_free()
		print("Successful token verification")
	else:
		print("Login failed, please try again")
		get_node("../UI/Login_Screen/LoginScreen").loginButton.disabled = false





