extends "res://assets/Countdowns/Countdown.gd"
	
func on_countdown_end():
	emit_signal("end_game")