extends Control

@export var Address = "207.127.90.3"
@export var Port = 2456
var peer

# Called when the node enters the scene tree for the first time.
func _ready():
	multiplayer.connected_to_server.connect(connected_to_server)
	multiplayer.server_disconnected.connect(disconnected_from_server)
	multiplayer.connection_failed.connect(connection_failed)
	
# From client
func connected_to_server():
	print("Connected to server")
	
func disconnected_from_server():
	print("Server disconnected")
	
# From client
func connection_failed():
	print("Couldnt Connect")

func _on_join_button_down():
	peer = WebSocketMultiplayerPeer.new()
	var err = peer.create_client(Address + ':' + str(Port))
	if err != OK:
		print('Unable to connect')
		return
	multiplayer.set_multiplayer_peer(peer)
	
@rpc("any_peer")
func SendPlayerInformation(name, id):
	if !GameManager.Players.has(id):
		GameManager.Players[id] = {
			"name": name,
			"id": id,
			"score": 0
		}
		
	if multiplayer.is_server():
		for i in GameManager.Players:
			SendPlayerInformation.rpc(GameManager.Players[i].name, i)

func _on_start_game_button_down():
	StartGame.rpc()

func _on_host_button_down():
	StartServer()
	
@rpc("any_peer", "call_local")
func StartGame():
	var scene = load("res://assets/scenes/world.tscn").instantiate()
	get_tree().root.add_child(scene)
	self.hide()
	
func StartServer():
	var scene = load("res://assets/server/server.tscn").instantiate()
	get_tree().root.add_child(scene)
	self.hide()
