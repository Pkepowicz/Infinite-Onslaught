extends Node2D


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent().has_method("pickup"):
		var returned_node = area.get_parent().pickup()
		var node_to_add = returned_node.instantiate()
		get_parent().add_child(node_to_add)
