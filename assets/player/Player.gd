extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var id : int
var username : String
@onready var attack_cooldown = $GunRotation/Timer
@onready var animator = $AnimationPlayer

var sync_pos = Vector2(0,0)
var sync_rot = 0

var last_velocity : Vector2 = Vector2.ZERO
@export var basic_bullet : PackedScene
@onready var bullet = basic_bullet
@export var flash_color : Color
@export var flash_timeout : float
@export var vel : Vector2
@onready var input = $PlayerInput


func _enter_tree():
	set_multiplayer_authority(str(name).to_int())

func _ready():
	set_physics_process(multiplayer.is_server())
	$ServerSync.set_multiplayer_authority(1)
	$HitBox.set_multiplayer_authority(1)
	
func update_label():
	username = get_parent().player_info[str(name).to_int()].username
	$Username.text = username
	
func _physics_process(delta):
	#if not is_multiplayer_authority():
		#global_position = global_position.lerp(sync_pos, 0.4)
		#$GunRotation.rotation_degrees = lerpf($GunRotation.rotation_degrees, sync_rot, 0.4)
		#return
	$GunRotation.look_at(input.mouse_position)
	if input.shooting && attack_cooldown.is_stopped():
		attack_cooldown.start()
		Fire.rpc()
	
	input.shooting = false
	
	#if Input.is_action_just_pressed("SpecialButton"):
		#get_parent().send_Shockwave(get_global_position())
	
	#sync_pos = global_position
	#sync_rot = $GunRotation.rotation_degrees

	var direction = (Vector2(input.direction.x, input.direction.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.y = direction.y * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)

	move_and_slide()


@rpc("any_peer", "call_local")
func Fire():
	var b = bullet.instantiate()
	b.parent = self
	b.global_position = $GunRotation/BulletSpawn.global_position
	b.rotation_degrees = $GunRotation.rotation_degrees
	get_tree().root.add_child(b)
	bullet = basic_bullet
	
func set_bullet(obj: PackedScene):
	bullet = obj

func _on_hit_box_update_color_signal(clr, after_hit):
	var inner: Sprite2D = $Graphics/Inner
	var outer: Sprite2D = $Graphics/Outer
	if after_hit:
		inner.modulate = flash_color
		outer.modulate = flash_color
		animator.play("hit")
		await get_tree().create_timer(flash_timeout).timeout
	inner.modulate = clr
	outer.modulate = clr

func _on_hit_box_get_knocked_back(dir: Vector2) -> void:
	velocity += dir * 2000

func _on_hit_box_player_death(last_hit):
	get_parent().send_Shockwave(get_global_position())
	if multiplayer.is_server():
		get_parent().respawn_player(str(name).to_int())
		if last_hit:
			get_parent().update_player_scores(last_hit.to_int())
	queue_free()


