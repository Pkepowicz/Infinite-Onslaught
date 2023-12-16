extends Node2D

var parent: Node

@export var damage: int
@export var knockback_force: float

func set_parent(nd: Node):
	parent = nd

func deal_damage(area: Area2D) -> void:
	var dmg: Damage = Damage.new()
	dmg.dmg = damage
	dmg.knockback_origin = get_parent().position
	dmg.knockback_force = knockback_force
	
	area.get_parent().take_damage(dmg)
	get_parent().queue_free()

func _on_area_2d_area_entered(area):
	if area.get_parent().has_method("take_damage"):
		if area.get_parent().parent == parent:
			return
		deal_damage(area)
