extends Control

@export var Address = "127.0.0.1"
@export var Port = 2456
var peer

# Called when the node enters the scene tree for the first time.
func _ready():
	multiplayer.peer_connected.connect(peer_connected)
	multiplayer.peer_disconnected.connect(peer_disconnected)
	multiplayer.connected_to_server.connect(connected_to_server)
	multiplayer.connection_failed.connect(connection_failed)

	
@rpc("any_peer", "call_local")
func StartGame():
	var scene = load("res://assets/scenes/world.tscn").instantiate()
	get_tree().root.add_child(scene)
	self.hide()
	
func StartServer():
	var scene = load("res://assets/server/server.tscn").instantiate()
	get_tree().root.add_child(scene)
	self.hide()

# From server and client
func peer_connected(id):
	print("Player Connected " + str(id))

# From server and client
func peer_disconnected(id):
	print("Player Disconnected " + str(id))
	GameManager.Players.erase(id)
	var Players = get_tree().get_nodes_in_group("Player")
	for i in Players:
		if i.name == str(id):
			i.queue_free()

# From client
func connected_to_server():
	print("Connected to server")
	SendPlayerInformation.rpc_id(1, $LineEdit.text, multiplayer.get_unique_id())
	
# From client
func connection_failed():
	print("Couldnt Connect")
	
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

func _on_join_button_down():
	peer = WebSocketMultiplayerPeer.new()
	peer.create_client(Address + ':' + str(Port))
	multiplayer.set_multiplayer_peer(peer)

func _on_start_game_button_down():
	StartGame.rpc()

func _on_host_button_down():
	StartServer()
