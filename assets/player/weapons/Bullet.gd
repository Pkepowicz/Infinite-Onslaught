extends CharacterBody2D


const SPEED = 500.0
var direction : Vector2
var parent: Node
var knockback_force: float
var damage: int

func _ready():
	direction = Vector2(1,0).rotated(rotation)
	$DamageBox.set_parent(parent)
	delete_on_timer(5)

func _physics_process(delta):
	velocity = SPEED * direction

	move_and_slide()

func delete_on_timer(seconds):
	await get_tree().create_timer(seconds).timeout
	queue_free()
	
