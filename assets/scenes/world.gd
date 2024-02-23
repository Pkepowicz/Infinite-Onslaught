extends Node2D

@onready var address_entry = $MainMenu/MainMenu/MarginContainer/VBoxContainer/AddressEntry
@onready var level = $Level

@export var game_length : int
@export var game_break_lenght : int
@export var player_respawn_time : int
const Shockwave = preload("res://assets/Utils/shockwave/shockwave.tscn")

const Player = preload("res://assets/player/player.tscn")
const PORT = 2456
var is_dedicated_server = false
var is_game_over : bool
var peer = ENetMultiplayerPeer.new()
var player_info = {}
var late_player = []

# For hosting headless server
func _ready():
	if '--server' in OS.get_cmdline_args():
		is_dedicated_server = true
		host_server()

# Mandatory for websockets to work
func _process(delta):
	multiplayer.multiplayer_peer.poll()

func host_server():
	$MainMenu.hide()
	level.show()
	$GameTime.show()
	
	#if '--server' in OS.get_cmdline_args():
		#var server_certs = load("res://assets/Keys/server.crt")
		#var server_key = load("res://assets/Keys/server.key")
		#var server_tls_options = TLSOptions.server(server_key, server_certs)
		#peer.create_server(PORT, "*", server_tls_options)
		##peer.create_server(PORT)
	#else:
		#peer.create_server(PORT)
	peer.create_server(PORT)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(add_player)
	multiplayer.peer_disconnected.connect(remove_player)
	is_game_over = false
	$Level/PoweupSpawnPoints.start_spawning()
	$GameTime/TimerContainer.start_countdown(game_length)
	print("Waiting for players!")

func _on_join_button_button_down():
	multiplayer.connected_to_server.connect(on_player_connected)
	print("Trying to connect")
	$MainMenu/MainMenu.hide()
	$MainMenu/Loading.show()
	
	var is_connected = false
	#var client_trusted_cas = load("res://assets/Keys/server.crt")
	#var client_tls_options = TLSOptions.client_unsafe(client_trusted_cas)
	#var error = peer.create_client("wss://" + address_entry.text + ":" + str(PORT))
	var error = peer.create_client(address_entry.text, PORT)
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
			$GameTime.show()
		else:
			connection_error("Connection timed out")
	
func is_connection_estabilished(peer : ENetMultiplayerPeer):
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
	if is_game_over:
		show_starting_screen.rpc_id(peer_id)
	create_player(peer_id)
	$Level/PoweupSpawnPoints.sync_existing_powerups(peer_id)

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
			"username" = username,
			"score" = 0
		}
	
	if multiplayer.is_server():
		for i in player_info:
			sync_player_info.rpc(player_info[i].username, i)
		update_player_labels.rpc()

@rpc("authority", "call_remote", "reliable")
func sync_player_score(id, score):
	player_info[id].score = score
	
@rpc("authority", "call_local", "reliable")
func hide_death_screen():
	$DeathScreen.hide()

# Function used by server to notify client of his player's position on startup
@rpc("authority", "call_local")
func sync_player_position(pos):
	var player = get_node_or_null(str(multiplayer.get_unique_id()))
	if player:
		player.position = pos

# Function used by server to notify client to update player's labels
@rpc("authority", "call_local", "reliable")
func update_player_labels():
	var players = get_tree().get_nodes_in_group("Player")
	for player in players:
		player.update_label()

func update_player_scores(point_scorer):
	if !player_info.has(point_scorer):
		return
	player_info[point_scorer].score += 1
	
	if multiplayer.is_server():
		sync_player_score.rpc(point_scorer, player_info[point_scorer].score)

# Function called on server to add player instance
func create_player(peer_id):
	if is_game_over:
		late_player.append(peer_id)
		return
	var player = Player.instantiate()
	player.name = str(peer_id)
	var pos = level.get_spawn()
	player.global_position = pos
	player.sync_pos = pos
	add_child(player)
	sync_player_position.rpc_id(peer_id, pos)

# Function gets called only on server's player
func respawn_player(peer_id, seconds_to_spawn = player_respawn_time, notify_player = true):
	print("Respawn called in: " + str(multiplayer.get_unique_id()))
	if notify_player:
		respawn_time.rpc_id(peer_id, seconds_to_spawn)
	await get_tree().create_timer(seconds_to_spawn).timeout
	create_player(peer_id)
	update_player_labels.rpc()

@rpc("authority", "call_remote", "reliable")
func show_starting_screen():
	$StartingScreen.show()

@rpc("authority", "call_remote", "reliable")
func hide_starting_screen():
	$StartingScreen.hide()

@rpc("authority", "call_local", "reliable")
func respawn_time(seconds_to_spawn):
	$DeathScreen.show()
	$DeathScreen/TimerContainer.start_countdown(seconds_to_spawn)
	
@rpc("authority", "call_local", "reliable")
func endgame_time(seconds_to_spawn, players_score):
	$EndGameScreen.show_scores(players_score)
	$EndGameScreen/TimerContainer.start_countdown(seconds_to_spawn)
	
func restart_game():
	is_game_over = true
	var players = get_tree().get_nodes_in_group("Player")
	var players_to_spawn = []
	var players_score = []
	for player in players:
		players_to_spawn.append(player.name)
		player.queue_free()
	for player_id in player_info:
		players_score.append(player_info[player_id].duplicate())
		player_info[player_id].score = 0
	players_score.sort_custom(comparePlayers)
	print(players_score)
	endgame_time.rpc(game_break_lenght, players_score)
	hide_death_screen.rpc()
	await get_tree().create_timer(game_break_lenght).timeout
	is_game_over = false
	for player_id in players_to_spawn:
		if player_info.has(player_id.to_int()):
			respawn_player(player_id.to_int(), 0, false)
	for player_id in late_player:
		if player_info.has(player_id):
			hide_starting_screen.rpc_id(player_id)
			respawn_player(player_id, 0, false)
		late_player.erase(player_id)
	$GameTime/TimerContainer.start_countdown(game_length)

# Hosting server locally, mainly for debug purpose
func _on_host_button_button_down():
	host_server()
	player_info[1] = {
		"username" = "host",
		"score" = 0
	}
	add_player(multiplayer.get_unique_id())
	update_player_labels()

func _on_timer_container_end_game():
	restart_game()

func comparePlayers(a, b):
	if a["score"] < b["score"]:
		return false
	return true

func send_Shockwave(position):
	var new_shockwave = Shockwave.instantiate()
	new_shockwave.position = position
	add_child(new_shockwave)
