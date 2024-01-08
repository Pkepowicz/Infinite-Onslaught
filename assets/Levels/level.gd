extends Node2D

@onready var spawn_points = $SpawnPoints.get_children()
## minimum distance of spawn point to another player to be able
## to spawn new player on this spawn point
@export var min_spawn_separation_distance: float

func get_spawn():
	spawn_points.shuffle()
	for point in spawn_points:
		print("Checking point: ", point)
		if point.can_spawn_here():
			return point.global_position


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(spawn_points.size())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
