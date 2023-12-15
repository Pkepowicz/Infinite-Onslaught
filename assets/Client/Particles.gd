extends TextureRect

@onready var particle1 = $GPUParticles2D
@onready var particle2 = $GPUParticles2D2

func _process(delta):
	var canvas = get_canvas_transform()
	var top_left = -canvas.origin / canvas.get_scale()
	var size = get_viewport_rect().size / canvas.get_scale()

	particle1.global_position.x = top_left.x + size.x/2 
	particle1.global_position.y = top_left.y - 50
	particle1.get_process_material().set_emission_box_extents(Vector3(size.x,50,1))

	particle2.global_position.x = top_left.x + size.x/2 
	particle2.global_position.y = top_left.y - 50
	particle2.get_process_material().set_emission_box_extents(Vector3(size.x,50,1))
