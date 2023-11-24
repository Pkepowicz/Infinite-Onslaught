extends Node2D

@export var Address = "207.127.90.3"
@export var Port = 2456
var peer

func _ready():
	multiplayer.peer_connected.connect(peer_connected)
	multiplayer.peer_disconnected.connect(peer_disconnected)
	hostGame()

func hostGame():
	print("Starting Server!")
	alive()
	peer = WebSocketMultiplayerPeer.new()
	var error = peer.create_server(Port, Address)
	if error != OK:
		print("Cannot host: " + str(error))
		return
	
	multiplayer.set_multiplayer_peer(peer)
	print("Waiting For Players!")

func alive():
	while true:
		await get_tree().create_timer(60.0).timeout
		print("I'm still alive!")

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
	
	
