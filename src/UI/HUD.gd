extends CanvasLayer


func set_score(value: int) -> void:
	$CenterContainer/Score.text = "Score %d" % value


func set_life(value: int) -> void:
	$LeftContainer/HeartProgress.set_step(value)


func show_game_over(new_best: bool) -> void:
	$GameOver.visible = true
	$GameOver.modulate = Color(1, 1, 1, 0)
	$GameOver.find_node("NewBest").visible = new_best
	$GameOver/Tween.interpolate_method(
		self, "_change_game_over_opacity",
		0.0, 1.0, 1,
		Tween.TRANS_SINE, Tween.EASE_OUT
	)
	$GameOver/Tween.start()


func _change_game_over_opacity(value: float) -> void:
	$GameOver.modulate = Color(1, 1, 1, value)
