extends Node2D

@export var possible_pickups: Array[PackedScene]

var last_num : int = -1
	
# Called on server
func sync_existing_powerup(peer_id):
	print("Spawner sends actual pickup")
	if get_child_count() != 0 and last_num != -1:
		spawn_powerup.rpc_id(peer_id, last_num)
	
func start_pickup_generation_random_timer():
	# choose random time for timer, when it runs out spawn pickup 
	if(!multiplayer.is_server()):
		return
	var random_first_spawn_time = randi() % 5 + 5
	print("random time chosen: ", random_first_spawn_time)
	$Timer.start(random_first_spawn_time)

func _on_timer_timeout():
	if multiplayer.is_server():
		last_num = randi() % possible_pickups.size()
		spawn_powerup.rpc(last_num)
	
@rpc("call_local", "reliable")
func spawn_powerup(num):
	# instanciate powerup here
	print("timer ran out, trying to spawn pickup", name)
	var powerup = possible_pickups[num].instantiate()
	add_child(powerup)


func _on_area_2d_area_exited(area: Area2D) -> void:
	# check if the body that exited(was picked up) is powerup, if it is, start spawn timer
	if area.get_parent().has_method("pickup"):
		print("powerup picked up")
		start_pickup_generation_random_timer()
	
