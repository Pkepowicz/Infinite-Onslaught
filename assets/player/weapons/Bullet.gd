extends CharacterBody2D


const SPEED = 500.0
var direction : Vector2

var knockback_force: float
var damage: int

func _ready():
	direction = Vector2(1,0).rotated(rotation)

func _physics_process(delta):
	velocity = SPEED * direction

	move_and_slide()
