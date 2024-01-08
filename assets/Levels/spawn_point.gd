extends Node2D

@export var spawn_prevention_radius: float = 4
var spawn_prevention: bool = false

func can_spawn_here()-> bool:
	if spawn_prevention:
		return false
	var objects_in_range = $Area2D.get_overlapping_areas()
	print(objects_in_range)
	for obj in objects_in_range:
		if obj.get_parent().get_parent().is_in_group("Player"):
			print("point already occupied")
			return false
	$Timer.start()
	spawn_prevention = true
	return true
	

func _on_timer_timeout() -> void:
	spawn_prevention = false
