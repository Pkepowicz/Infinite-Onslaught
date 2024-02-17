extends MultiplayerSynchronizer

@export var direction : Vector2


func _ready():
	# Only process for the local player.
	set_process(get_parent().name == str(multiplayer.get_unique_id()))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
