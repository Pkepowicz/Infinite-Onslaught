class_name LavaTile extends Node2D

@onready var area: Area2D = $Area2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	LavaManager.instance.add_tile_to_array(self)

func deal_damage(dmg: Damage) -> void:
	
	var areas: Array[Area2D] = area.get_overlapping_areas ()
	print("trying to deal damage on these areas: ", areas)
	for ar in areas:
		print(ar)
		if ar.get_parent().has_method("take_damage"):
			print("tile ", self, " dealt damage to ", ar.get_parent())
			ar.get_parent().take_damage(dmg)
			

