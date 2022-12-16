extends Node

var token
var client_clock: int
var delta_latency: float = 0
var decimal_collector: float = 0
var latency_array = []
var latency

var network = NetworkedMultiplayerENet.new()

var ip = "127.0.0.1"


var port = 12030


func _physics_process(delta: float) -> void:
	client_clock += int(delta*1000) + delta_latency
	delta_latency -= delta_latency
	decimal_collector += (delta*1000) - int(delta*1000)
	if decimal_collector >= 1.00:
		client_clock += 1
		decimal_collector -= 1.00


func ConnectToServer():
	network.create_client(ip, port)
	get_tree().set_network_peer(network)
	
	network.connect("connection_failed", self, "_OnConnectionFailed")
	network.connect("connection_succeeded", self, "_OnConnectionSucceeded")


func _OnConnectionFailed():
	print("Failed to connect :/")

func _OnConnectionSucceeded():
	print("Succesfully connected to game server")
	rpc_id(1, "FetchServerTime", OS.get_system_time_msecs())
	var timer = Timer.new()
	timer.wait_time = 0.5
	timer.autostart = true
	timer.connect("timeout", self, "DetermineLatency")
	self.add_child(timer)


func DetermineLatency():
	rpc_id(1, "DetermineLatency", OS.get_system_time_msecs())


remote func ReturnServerTime(server_time, client_time):
	latency = (OS.get_system_time_msecs() - client_time) / 2
	client_clock = server_time + latency


remote func ReturnLatency(client_time):
	latency_array.append((OS.get_system_time_msecs() - client_time) / 2)
	if latency_array.size() == 9:
		var total_latency = 0
		latency_array.sort()
		var mid_point = latency_array[4]
		
		for i in range(latency_array.size()-1,-1,-1):
			if latency_array[i] > (2 * mid_point) and latency_array[i] > 20:
					latency_array.remove(i)
			
			else:
				total_latency += latency_array[i]
		
		delta_latency = (total_latency / latency_array.size()) - latency
		latency = total_latency / latency_array.size()
		latency_array.clear()

func SendPlayerState(player_state, IDE):
	rpc_unreliable_id(1, "ReceivePlayerState", player_state, IDE)


remote func ReceiveWorldState(world_state, unit_Num, player_state):
	get_node("/root/Main").UpdateWorldState(world_state, unit_Num, player_state)


remote func PlayerSpawnUnit(UnitID, IDEN):
	get_node("/root/Main").PlayerSpawnUnit(UnitID, IDEN)


remote func FetchToken():
	rpc_id(1, "ReturnToken", token)



func FetchData(skill_name, requester):
	
	rpc_id(1, "Fetch_Data", skill_name, requester)


func SendBackPlayerState(Player_State):
	rpc_id(1, "UpdatePlayerState", Player_State)



remote func ReturnData(s_data, requester):
	instance_from_id(requester).UpdateData(s_data)



remote func ReturnTokenVerificationResults(result):
	if result == true:
		get_node("/root/Ui_background/GUI").queue_free()
		print("Successful token verification")
	else:
		print("Login failed, please try again")
		get_node("../UI/Login_Screen/LoginScreen").loginButton.disabled = false



remote func SpawnNewTent(player_id, spawn_position):
	print("spawning new tent")
	Project.main.SpawnTent(player_id, spawn_position)



func RequestSpawnTent():
	rpc_id(1, "SpawnTent")



# Request's the server to spawn a unit
func RequestSpawnUnit(UnitID, IDEN):
	""" UNIT IDS 1 = KNIGHT 2 = CATAPULT = ARCHER"""
	print("requesting spawn")
	rpc_id(1, "SpawnUnit", UnitID, IDEN)



remote func SpawnUnit(player_state_collection, unit_NUM, UnitCreatorID):
	# ID 1 = Knight ID 2 = Catapult ID 3 = archer
	Project.main.SpawnUnit(player_state_collection, unit_NUM)


func Send_Hit_Data(player_id, player_IDE, damage_taken):
	rpc_id(1, "Receive_Hit_Data", player_id, player_IDE, damage_taken)

remote func Return_Hit_Data(Unit_IDE, damage_taken):
	Project.main.Inflict_damage(Unit_IDE, damage_taken)

remote func Kill_Unit(IDEN):
	Project.main.Erase(IDEN)

remote func Tent_Update(TentState, player_id):
	Project.main.TentUpdate(TentState, player_id)

