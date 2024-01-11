extends CanvasLayer


func show_scores(player_scores_sorted : Array):
	show()
	var score_len = player_scores_sorted.size()
	if score_len <= 0:
		return
	$TimerContainer/PlayerScore1.set_text("1. " + player_scores_sorted[0].username + " ... " + str(player_scores_sorted[0].score))
	if score_len <= 1:
		return
	$TimerContainer/PlayerScore2.set_text("2. " + player_scores_sorted[1].username + " ... " + str(player_scores_sorted[1].score))
	if score_len <= 2:
		return
	$TimerContainer/PlayerScore3.set_text("3. " + player_scores_sorted[2].username + " ... " + str(player_scores_sorted[2].score))
