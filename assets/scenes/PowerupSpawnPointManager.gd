extends Node2D


func sync_existing_powerups(peer_id):
	var spawners = get_children()
	for spawner in spawners:
		spawner.sync_existing_powerup(peer_id)

func start_spawning():
	print("started powerup spawning")
	var spawners = get_children()
	for spawner in spawners:
		spawner.start_pickup_generation_random_timer()
