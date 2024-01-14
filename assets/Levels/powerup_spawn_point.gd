extends Node2D

@export var possible_pickups: Array[PackedScene]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_pickup_generation_random_timer()
	
func start_pickup_generation_random_timer():
	# choose random time for timer, when it runs out spawn pickup 
	if(!multiplayer.is_server()):
		return
	var random_first_spawn_time = randi() % 5 + 5
	print("random time chosen: ", random_first_spawn_time)
	$Timer.start(random_first_spawn_time)




func _on_timer_timeout() -> void:
	# instanciate powerup here
	print("timer ran out, trying to spawn pickup", name)
	var powerup_to_spawn = possible_pickups[randi() % possible_pickups.size()].instantiate()
	#powerup_to_spawn.global_position = global_position
	add_child(powerup_to_spawn)
	print(powerup_to_spawn.name, powerup_to_spawn.global_position, " ", global_position)


func _on_area_2d_area_exited(area: Area2D) -> void:
	# check if the body that exited(was picked up) is powerup, if it is, start spawn timer
	if area.get_parent().has_method("pickup"):
		print("powerup picked up")
		start_pickup_generation_random_timer()
	
