extends GPUParticles2D

@onready var timer = $Timer

func _ready():
	timer.start()
	emitting = true

func _on_timer_timeout():
	queue_free()
