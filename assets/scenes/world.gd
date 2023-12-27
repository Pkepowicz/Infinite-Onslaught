extends Node2D

@onready var address_entry = $MainMenu/MainMenu/MarginContainer/VBoxContainer/AddressEntry
@onready var level = $Level


const Player = preload("res://assets/player/player.tscn")
const PORT = 2456
var peer = WebSocketMultiplayerPeer.new()
var player_info = {}


# For hosting headless server
func _ready():
	if '--server' in OS.get_cmdline_args():
		host_server()

# Mandatory for websockets to work
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
	multiplayer.connected_to_server.connect(on_player_connected)
	print("Trying to connect")
	$MainMenu/MainMenu.hide()
	$MainMenu/Loading.show()
	
	var is_connected = false
	var error = peer.create_client(address_entry.text + ":" + str(PORT))
	multiplayer.multiplayer_peer = peer
	# Checking errors during socket creation
	if error != OK && error != ERR_ALREADY_IN_USE:
		connection_error(error_string(error))
	else:
		# Loop to check if connection is estabilished
		# Default timeout value for websocket is 3 seconds
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

# Returns to main menu and shows error message
func connection_error(error : String):
	$MainMenu/MainMenu/MarginContainer/VBoxContainer/ErrorMessage.text = error
	$MainMenu/MainMenu/MarginContainer/VBoxContainer/ErrorMessage.show()
	$MainMenu/Loading.hide()
	$MainMenu/MainMenu.show()

# Function called only on server when new peer connects
func add_player(peer_id):
	print("Connected: " + str(peer_id) )
	var player = Player.instantiate()
	player.name = str(peer_id)
	var pos = level.get_spawn()
	player.global_position = pos
	add_child(player)
	sync_player_position.rpc_id(peer_id, pos)

# Function called only on server when peer disconnects
func remove_player(peer_id):
	print("Disconnected: " + str(peer_id) )
	var player = get_node_or_null(str(peer_id))
	if player:
		player.queue_free()
	player_info.erase(peer_id)

# Function called on peer after connetion is estabilished
func on_player_connected():
	var username = $MainMenu/MainMenu/MarginContainer/VBoxContainer/NameEntry.text
	var id = multiplayer.get_unique_id()
	sync_player_info.rpc_id(1, username, id)

# Function that syncs player info dict across all hosts
# Synchronization is initiated by new peer during on_player_connected
# Server gets information from new peer,
# and then sends all dict entries to all connected clients
# At the end sends signal to all clients to update player labels
@rpc("any_peer", "call_remote", "reliable")
func sync_player_info(username, id):
	if !player_info.has(id):
		player_info[id] = {
			"username" = username
		}
	
	if multiplayer.is_server():
		for i in player_info:
			sync_player_info.rpc(player_info[i].username, i)
		update_player_labels.rpc()

# Function used by server to notify client of his player's position on startup
@rpc("authority", "call_local")
func sync_player_position(pos):
	var player = get_node_or_null(str(multiplayer.get_unique_id()))
	player.position = pos

# Function used by server to notify client to update player's labels
@rpc("authority", "call_local", "reliable")
func update_player_labels():
	var players = get_tree().get_nodes_in_group("Player")
	for player in players:
		player.update_label()

# Hosting server locally, mainly for debug purpose
func _on_host_button_button_down():
	host_server()
	player_info[1] = {
		"username" = "host"
	}
	add_player(multiplayer.get_unique_id())
	update_player_labels()
