extends Node2D

@onready var spawn_points = $SpawnPoints.get_children()
## minimum distance of spawn point to another player to be able
## to spawn new player on this spawn point
@export var min_spawn_separation_distance: float

func spawn_player(player_to_spawn)-> void:
	for point in spawn_points:
		print("Checking point: ", point)
		if point.can_spawn_here():
			player_to_spawn.position = point.global_position
			get_parent().add_child(player_to_spawn)
			return


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(spawn_points.size())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
