extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var id : int
var username : String
@onready var attack_cooldown = $GunRotation/Timer

var sync_pos = Vector2(0,0)
var sync_rot = 0

@export var basic_bullet : PackedScene
@onready var bullet = basic_bullet

func _enter_tree():
	set_multiplayer_authority(str(name).to_int())
	
func update_label():
	username = get_parent().player_info[str(name).to_int()].username
	$Username.text = username
	
func _physics_process(delta):
	if not is_multiplayer_authority():
		global_position = global_position.lerp(sync_pos, 0.4)
		$GunRotation.rotation_degrees = lerpf($GunRotation.rotation_degrees, sync_rot, 0.4)
		return
	$GunRotation.look_at(get_viewport().get_mouse_position())
	if Input.is_action_just_pressed("Fire") && attack_cooldown.is_stopped():
		attack_cooldown.start()
		print(username)
		Fire.rpc()
	
	if Input.is_action_just_pressed("SpecialButton"):
		print(get_parent().player_info)
	
	sync_pos = global_position
	sync_rot = $GunRotation.rotation_degrees
	var direction_x = Input.get_axis("ui_left", "ui_right")
	var direction_y = Input.get_axis("ui_up", "ui_down")
	if direction_x:
		velocity.x = direction_x * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	if direction_y:
		velocity.y = direction_y * SPEED
	else:
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

func _on_hit_box_update_color_signal(clr):
	var inner: Sprite2D = $Graphics/Inner
	var outer: Sprite2D = $Graphics/Outer
	inner.modulate = clr
	outer.modulate = clr

func _on_hit_box_get_knocked_back(dir: Vector2) -> void:
	velocity += dir * 2000

func _on_hit_box_player_death(last_hit):
	if multiplayer.is_server():
		get_parent().respawn_player(str(name).to_int())
		if last_hit:
			get_parent().update_player_scores(last_hit.to_int())
	queue_free()


