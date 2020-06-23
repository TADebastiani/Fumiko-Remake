extends Control


func _ready() -> void:
	$Tween.interpolate_property($Node2D, "position",
		Vector2(0, 250),
		Vector2(0, 0),
		10)
	$Tween.start()


func _on_Back_pressed() -> void:
	get_tree().change_scene("res://src/UI/Menu.tscn")
