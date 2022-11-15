extends Node


var network = NetworkedMultiplayerENet.new()
var gateway_api = MultiplayerAPI.new()
var ip = "127.0.0.1"
var port = 1910

var username
var password
var new_account = false


func _process(delta):
	if get_custom_multiplayer() == null:
		return
	if not custom_multiplayer.has_network_peer():
		return;
	custom_multiplayer.poll();

func ConnectToServer(_username, _password, _new_account):
	print("Trying to connect to server")
	network = NetworkedMultiplayerENet.new()
	gateway_api = MultiplayerAPI.new()
	username = _username
	password = _password
	new_account = _new_account
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
	if new_account == true:
		RequestCreateAccount()
	else:
		RequestLogin()


func RequestCreateAccount():
	print("Creating new account")
	rpc_id(1, "CreateAccountRequest", username, password)
	username = ""
	password = ""

func RequestLogin():
	print("Connecting to gateway to request login")
	rpc_id(1, "LoginRequest", username, password)
	username = ""
	password = ""


remote func ReturnLoginRequest(results, token):
	print("results received")
	if results == true:
		Server.token = token
		Server.ConnectToServer()
	else:
		print("Please provide correct username and password")
	network.disconnect("connection_failed", self, "ConnectionFailed")
	network.disconnect("connection_succeeded", self, "ConnectionSucceeded")


remote func ReturnCreateAccountRequest(results, message):
	print("results received")
	if results == true:
		print("Account created, please proceed with logging in")
		get_node("/root/Ui_background/GUI/CreateAccount/Back_button").on_Back_button_pressed()
	else:
		if message == 1:
			print("Couldn't creae account, Please try again")
		if message == 2:
			print("That username already exists, please use a different username")
			get_node("/root/Ui_background/GUI").Confirm_Button.disabled = false
			get_node("/root/Ui_background/GUI").Back_button.disabled = false
	network.disconnect("connection_failed", self, "ConnectionFailed")
	network.disconnect("connection_failed", self, "ConnectionSucceeded")


