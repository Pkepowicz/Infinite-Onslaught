extends Node2D

@export var immunity_time: float = 5


func _ready() -> void:
	get_parent().get_node("HitBox").immune = true
	print("Shield pickup added")
	await get_tree().create_timer(immunity_time).timeout
	end_immunity_time()
	
	
func end_immunity_time():
	get_parent().get_node("HitBox").immune = false
	print("Shield pickup removed")
	queue_free()

