extends Node2D

@export var spawn_prevention_radius: float = 2

func can_spawn_here()-> bool:
	var objects_in_range = $Area2D.get_overlapping_areas()
	for obj in objects_in_range:
		if obj.get_parent().get_parent().is_in_group("Player"):
			print("point already occupied")
			return false
	return true
