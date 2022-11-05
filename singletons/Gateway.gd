extends Node


var network = NetworkedMultiplayerENet.new()
var gateway_api = MultiplayerAPI.new()
var ip = "127.0.0.1"
var port = 1910

var username
var password

func _process(delta):
	if get_custom_multiplayer() == null:
		return
	if not custom_multiplayer.has_network_peer():
		return;
	custom_multiplayer.poll();

func ConnectToServer(_username, _password):
	print("Trying to connect to server")
	network = NetworkedMultiplayerENet.new()
	gateway_api = MultiplayerAPI.new()
	username = _username
	password = _password
	network.create_client(ip, port)
	set_custom_multiplayer(gateway_api)
	custom_multiplayer.set_root_node(self)
	custom_multiplayer.set_network_peer(network)
	
	network.connect("connection_failed", self, "ConnectionFailed")
	network.connect("connection_succeeded", self, "ConnectionSucceeded")

func ConnectionFailed():
	print("Failed to connected to AUTH")

func ConnectionSucceeded():
	print("Succeeded in connecting to AUTH")
	RequestLogin()


func RequestLogin():
	print("Connecting to gateway to request login")
	rpc_id(1, "LoginRequest", username, password)
	username = ""
	password = ""


remote func ReturnLoginRequest(results):
	print("results received")
	if results == true:
		Server.ConnectToServer()
		get_node("../Ui_background/GUI").queue_free()
	else:
		print("Please provide correct username and password")
		get_node("../UI/Login_Screen/LoginScreen").loginButton.disabled = false
	network.disconnect("connection_failed", self, "ConnectionFailed")
	network.disconnect("connection_succeeded", self, "ConnectionSucceeded")







