extends Node2D

@export var colors: Array[Color]
@export var max_hp: int = 5

var hp: int
var parent: Node

signal update_color_signal(clr: Color)

signal get_knocked_back(dir: Vector2)

func update_color():
	var color_to_set: Color = colors[max_hp-hp]
	update_color_signal.emit(color_to_set)

func _ready():
	hp = max_hp
	parent = get_parent()
	update_color()

func take_damage(dmg: Damage):
	hp -= dmg.dmg
	var knockback: Vector2 = (position - dmg.knockback_origin).normalized() * dmg.knockback_force
	if knockback != Vector2.ZERO:
		get_knocked_back.emit(knockback)
	
	update_color()



