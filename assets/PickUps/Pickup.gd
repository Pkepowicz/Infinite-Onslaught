class_name Pickup extends Node2D

@export var powerup_object: PackedScene

func pickup() -> PackedScene:
	queue_free()
	return powerup_object
