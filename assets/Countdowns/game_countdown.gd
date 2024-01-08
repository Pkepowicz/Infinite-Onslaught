extends "res://assets/Countdowns/Countdown.gd"

signal end_game

func on_countdown_end():
	emit_signal("end_game")
