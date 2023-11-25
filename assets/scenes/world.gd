extends Node2D

@onready var main_menu = $CanvasLayer/MainMenu
@onready var address_entry = $CanvasLayer/MainMenu/MarginContainer/VBoxContainer/AddressEntry

const Player = preload("res://assets/player/player.tscn")
const PORT = 2456
var enet_peer = ENetMultiplayerPeer.new()

func _ready():
	if '--server' in OS.get_cmdline_args():
		host_server()

func host_server():
	main_menu.hide()
	
	enet_peer.create_server(PORT)
	multiplayer.multiplayer_peer = enet_peer
	multiplayer.peer_connected.connect(add_player)
	multiplayer.peer_disconnected.connect(remove_player)
	print("Waiting for players!")

func _on_join_button_button_down():
	print("Trying to connect")
	main_menu.hide()
	
	enet_peer.create_client(address_entry.text, PORT)
	multiplayer.multiplayer_peer = enet_peer

func add_player(peer_id):
	print("Connected: " + str(peer_id) )
	var player = Player.instantiate()
	player.name = str(peer_id)
	add_child(player)

func remove_player(peer_id):
	print("Disconnected: " + str(peer_id) )
	var player = get_node_or_null(str(peer_id))
	if player:
		player.queue_free()

func _on_host_button_button_down():
	host_server()
	add_player(multiplayer.get_unique_id())
