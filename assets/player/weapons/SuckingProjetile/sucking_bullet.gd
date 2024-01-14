extends CharacterBody2D


var speed = 250.0
var direction : Vector2
var parent: Node
var knockback_force: float
var damage: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	direction = Vector2(1,0).rotated(rotation)
	delete_on_timer(6)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	speed = max(0, speed -0.52)
	velocity = speed * direction

	move_and_slide()
	var overlapping_objects = $Area2D.get_overlapping_areas()
	for object in overlapping_objects:
		if object.is_in_group("Player_hitbox") and object.get_parent().get_parent() != parent:
			var dir_vector = -position.direction_to(object.global_position).normalized()
			object.get_parent().get_parent().velocity += dir_vector * 120
	
	
func delete_on_timer(seconds):
	await get_tree().create_timer(seconds).timeout
	queue_free()
