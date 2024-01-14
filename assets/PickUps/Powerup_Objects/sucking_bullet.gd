extends Node2D

@export var sucking_bullet : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_parent().set_bullet(sucking_bullet)
	queue_free()
