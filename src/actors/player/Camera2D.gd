extends Camera2D

signal moved

onready var old_position_y: float = 0.0
onready var older_position_y: float = 0.0

func _process(_delta: float) -> void:
	var current_position_y = floor(get_camera_screen_center().y)

	if old_position_y > older_position_y  and old_position_y == current_position_y:
		emit_signal("moved", global_position)

	older_position_y = floor(old_position_y)
	old_position_y = floor(current_position_y)

