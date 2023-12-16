extends Node2D

@export var colors: Array[Color]
@export var max_hp = 5

var hp

signal update_color_signal(clr: Color)

func update_color():
	var color_to_set: Color = colors[max_hp-hp]
	update_color_signal.emit(color_to_set)

func _ready():
	hp = max_hp
	update_color()




