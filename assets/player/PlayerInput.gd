extends MultiplayerSynchronizer

@export var direction : Vector2
@export var shooting : bool
@export var mouse_position: Vector2

func _ready():
	# Only process for the local player.
	set_process(get_parent().name == str(multiplayer.get_unique_id()))

@rpc("call_local", "reliable")
func shoot():
	shooting = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	mouse_position = get_viewport().get_mouse_position()
	if Input.is_action_just_pressed("Fire"):
		shoot.rpc()
