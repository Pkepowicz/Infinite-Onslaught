extends Node2D

@onready var spawn_points = $SpawnPoints.get_children()
## minimum distance of spawn point to another player to be able
## to spawn new player on this spawn point
@export var min_spawn_separation_distance: float

func spawn_player(player_to_spawn)-> void:
	for point in spawn_points:
		if point.can_spawn_here():
			player_to_spawn.position = point.position
			add_child(player_to_spawn)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
