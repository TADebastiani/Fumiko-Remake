extends Control

export(PackedScene) var main_scene
export(PackedScene) var credits_scene


func _on_PlayButton_pressed() -> void:
	get_tree().change_scene_to(main_scene)


func _on_QuitButton_pressed() -> void:
	get_tree().quit()
