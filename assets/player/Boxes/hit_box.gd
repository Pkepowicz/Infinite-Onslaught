extends Node2D

@export var colors: Array[Color]
@export var max_hp: int = 5

var hp: int
var parent: Node

signal update_color_signal(clr: Color)

signal get_knocked_back(dir: Vector2)

func update_color():
	var color_percentage = 1 - float(hp)/float(max_hp)
	var red_value = clamp(2*color_percentage, 0, 1)
	var green_value = clamp(2*(-color_percentage)+2, 0, 1)
	var color_to_set = Color(red_value, green_value, 0, 1)
	update_color_signal.emit(color_to_set)

func _ready():
	hp = max_hp
	parent = get_parent()
	update_color()

func take_damage(dmg: Damage):
	hp -= dmg.dmg
	var knockback: Vector2 = (global_position - dmg.knockback_origin).normalized() * dmg.knockback_force
	if knockback != Vector2.ZERO:
		get_knocked_back.emit(knockback)
	if(hp <= 0):
		print("player died")
		return
	
	update_color()


