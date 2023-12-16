extends Node2D

@onready var address_entry = $MainMenu/MainMenu/MarginContainer/VBoxContainer/AddressEntry
@onready var level = $Level


const Player = preload("res://assets/player/player.tscn")
const PORT = 2456
var peer = WebSocketMultiplayerPeer.new()



func _ready():
	if '--server' in OS.get_cmdline_args():
		host_server()

func _process(delta):
	multiplayer.multiplayer_peer.poll()

func host_server():
	$MainMenu.hide()
	level.show()
	
	peer.create_server(PORT)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(add_player)
	multiplayer.peer_disconnected.connect(remove_player)
	print("Waiting for players!")

func _on_join_button_button_down():
	print("Trying to connect")
	$MainMenu/MainMenu.hide()
	$MainMenu/Loading.show()
	
	var is_connected = false
	var error = peer.create_client(address_entry.text + ":" + str(PORT))
	multiplayer.multiplayer_peer = peer
	if error != OK && error != ERR_ALREADY_IN_USE:
		connection_error(error_string(error))
	else:
		for i in range(13):
			is_connected = is_connection_estabilished(peer)
			if is_connected:
				break
			await get_tree().create_timer(0.25).timeout
		if is_connected:
			multiplayer.multiplayer_peer = peer
			$MainMenu.hide()
			level.show()
		else:
			connection_error("Connection timed out")
	
func is_connection_estabilished(peer : WebSocketMultiplayerPeer):
	print(peer.get_connection_status())
	if peer.get_connection_status() == MultiplayerPeer.CONNECTION_CONNECTED:
		return true
	return false

func connection_error(error : String):
	$MainMenu/MainMenu/MarginContainer/VBoxContainer/ErrorMessage.text = error
	$MainMenu/MainMenu/MarginContainer/VBoxContainer/ErrorMessage.show()
	$MainMenu/Loading.hide()
	$MainMenu/MainMenu.show()

func add_player(peer_id):
	print("Connected: " + str(peer_id) )
	var player = Player.instantiate()
	player.name = str(peer_id)
	level.spawn_player(player)
	#level.add_child(player)

func remove_player(peer_id):
	print("Disconnected: " + str(peer_id) )
	var player = get_node_or_null(str(peer_id))
	if player:
		player.queue_free()

func _on_host_button_button_down():
	host_server()
	add_player(multiplayer.get_unique_id())
