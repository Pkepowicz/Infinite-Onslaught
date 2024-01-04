extends VBoxContainer

@onready var timer = $TimeLabel/Timer
var seconds: int = 0

func start_countdown(seconds_to_set : int):
	seconds = seconds_to_set
	$TimeLabel.set_text(str(seconds))
	timer.start()

func _on_timer_timeout():
	print("timer timeout")
	seconds -= 1
	$TimeLabel.set_text(str(seconds))
	if seconds == 0:
		timer.stop()
		$"..".hide()
		$"../../ConclusionScreen".show()
