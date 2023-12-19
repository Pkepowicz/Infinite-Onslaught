extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var username : String

@export var bullet : PackedScene

func _enter_tree():
	set_multiplayer_authority(str(name).to_int())
	
func update_label():
	username = get_parent().player_info[str(name).to_int()].username
	$Username.text = username
	
func _physics_process(delta):
	if not is_multiplayer_authority():
		return
	$GunRotation.look_at(get_viewport().get_mouse_position())
	if Input.is_action_just_pressed("Fire"):
		print(username)
		Fire.rpc()
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


func _on_hit_box_update_color_signal(clr):
	var inner: Sprite2D = $Graphics/Inner
	var outer: Sprite2D = $Graphics/Outer
	inner.modulate = clr
	outer.modulate = clr

func _on_hit_box_get_knocked_back(dir: Vector2) -> void:
	velocity += dir * 2000
