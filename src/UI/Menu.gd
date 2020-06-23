extends Control

export(PackedScene) var main_scene
export(PackedScene) var credits_scene


func _ready() -> void:
	var score = Data.load_score()
	if score > 0:
		$Best.text = "Best score: %d" % score
	else:
		$Best.visible = false


func _on_PlayButton_pressed() -> void:
	var err = get_tree().change_scene_to(main_scene)
	if err:
		print("Error loading game!")
		print(err)


func _on_QuitButton_pressed() -> void:
	get_tree().quit()


func _on_CreditsButton_pressed() -> void:
	var err = get_tree().change_scene_to(credits_scene)
	if err:
		print("Error loading credits!")
		print(err)
