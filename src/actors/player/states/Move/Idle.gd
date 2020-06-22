extends State


func enter(_msg: Dictionary = {}) -> void:
	_parent.enter(_msg)
	_parent.velocity = Vector2.ZERO
	_parent.snap_vector.y = _parent.snap_distance

	owner.animation_player.play("idle")


func unhandled_input(_event: InputEvent) -> void:
	_parent.unhandled_input(_event)


func state_process(_delta: float) -> void:
	if owner.is_on_floor() and _parent.get_direction().x != 0.0:
		_state_machine.transition_to("Move/Run")
	elif not owner.is_on_floor():
		_state_machine.transition_to("Move/Air")
	else:
		_parent.state_process(_delta)


func exit() -> void:
	_parent.exit()
