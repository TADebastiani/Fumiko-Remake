extends State


func enter(_msg: Dictionary = {}) -> void:
	owner.animation_player.play("run")


func unhandled_input(event: InputEvent) -> void:
	_parent.unhandled_input(event)


func state_process(delta: float) -> void:
	if owner.is_on_floor():
		if _parent.get_direction().x == 0:
			_state_machine.transition_to("Move/Idle")
	else:
		_state_machine.transition_to("Move/Air")
	_parent.state_process(delta)


func exit() -> void:
	_parent.exit()
