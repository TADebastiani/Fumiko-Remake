extends State

signal jumped

onready var jump_delay: Timer = $JumpDelay


func enter(msg: Dictionary = {}) -> void:
	_parent.enter(msg)

	_parent.acceleration = Vector2(
		_parent.DEFAULT.ACCELERATION.x / 2,
		1500
	)

	_parent.snap_vector.y = 0
	if "impulse" in msg:
		_parent.velocity += calculate_jump_velocity(msg.impulse)
		print(calculate_jump_velocity(msg.impulse))


func unhandled_input(event: InputEvent) -> void:
	_parent.unhandled_input(event)


func state_process(delta: float) -> void:
	_parent.state_process(delta)
	if Input.is_action_just_released("jump") and _parent.velocity.y < 0:
		_parent.velocity.y = 0

	if owner.is_on_floor():
		var target_state := "Move/Idle" if _parent.get_direction().x == 0 else "Move/Run"
		_state_machine.transition_to(target_state)
	else:
		if _parent.velocity.y < 0:
			owner.animation_player.play("jump")
		else:
			owner.animation_player.play("fall")


func exit() -> void:
	_parent.acceleration = _parent.DEFAULT.ACCELERATION
	_parent.exit()


func calculate_jump_velocity(impulse: float) -> Vector2:
	return _parent.calculate_velocity(
		_parent.velocity,
		_parent.max_speed,
		Vector2(0, impulse),
		1.0,
		Vector2.UP
	)
