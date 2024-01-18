extends Node2D

@export var max_hp: int = 5
@onready var collision = $Area2D/CollisionShape2D
@onready var bleed_particles = preload("res://assets/Utils/particles/bleed_particles.tscn")

@export var hp: int
var parent: Node
var immune: bool = false
var last_hit

signal update_color_signal(clr: Color)

signal get_knocked_back(dir: Vector2)

signal player_death()

# Działa, będzie działać i tego nie ruszać ok?
func update_color(after_hit = true):
	var color_percentage = 1 - (float(hp)-1)/float(max_hp)
	var red_value = clamp(2*color_percentage, 0, 1)
	var green_value = clamp(2*(-color_percentage)+2, 0, 1)
	var color_to_set = Color(red_value, green_value, 0, 1)
	update_color_signal.emit(color_to_set, after_hit)

func _ready():
	hp = max_hp
	parent = get_parent()
	update_color(false)

func take_damage(dmg: Damage):	
	if immune:
		return
	hp -= dmg.dmg
	var knockback_coefficient = (float(max_hp - hp) / max_hp)
	var knockback: Vector2 = (global_position - dmg.knockback_origin).normalized() * dmg.knockback_force * knockback_coefficient
	if dmg.owner:
		last_hit = dmg.owner
	
	collision.call_deferred("set", "disabled", true)
	$Timer.start()
	
	var p = bleed_particles.instantiate()
	p.global_position = global_position
	get_tree().root.add_child(p)
	
	if knockback != Vector2.ZERO:
		get_knocked_back.emit(knockback)
	if(hp <= 0):
		print("player died")
		player_death.emit(last_hit)
		return
	update_color()

func _on_timer_timeout() -> void:
	collision.call_deferred("set", "disabled", false)
