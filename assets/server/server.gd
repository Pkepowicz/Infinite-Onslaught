extends Node2D

@export var Address = "127.0.0.1"
@export var Port = 2456
var maxPeers = 5
var connectedPeers = []
var peer

func _ready():
	multiplayer.peer_connected.connect(peer_connected)
	multiplayer.peer_disconnected.connect(peer_disconnected)
	#if "--server" in OS.get_cmdline_args():
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
	if connectedPeers.size() < maxPeers:
		connectedPeers.append(id)
		print("Player Connected " + str(id))
	else:
		multiplayer.multiplayer_peer.get_peer(id).peer_disconnect()
		queue_free()

# From server and client
func peer_disconnected(id):
	print("Player Disconnected " + str(id))
	GameManager.Players.erase(id)
	var Players = get_tree().get_nodes_in_group("Player")
	for i in Players:
		if i.name == str(id):
			i.queue_free()
	
	
