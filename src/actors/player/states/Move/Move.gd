extends State

const DEFAULT = {
	MAX_SPPED = Vector2(150, 400),
	ACCELERATION = Vector2(10000, 1000)
}

var maximum_speed: Vector2 = DEFAULT.MAX_SPPED
var acceleration: Vector2 = DEFAULT.ACCELERATION
var jump_impulse := 400

var velocity: Vector2 = Vector2.ZERO
var snap_distance := 32.0
var snap_vector := Vector2.ZERO


func enter(_msg: Dictionary = {}) -> void:
	snap_vector.y = snap_distance


func unhandled_input(event: InputEvent) -> void:
	if owner.is_on_floor():
		if event.is_action_pressed("jump"):
			_state_machine.transition_to("Move/Air", { impulse = jump_impulse })
		if event.is_action_pressed("action"):
			_state_machine.transition_to("Attack")


func state_process(delta: float) -> void:
	velocity = calculate_velocity(velocity, maximum_speed, acceleration, delta, get_direction())
	velocity = owner.move_and_slide_with_snap(velocity, snap_vector, owner.FLOOR_NORMAL)
	owner.flip(get_direction().x)


func get_direction() -> Vector2:
	var x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	return Vector2(x, 1)


func calculate_velocity(
		old_velocity: Vector2,
		max_speed: Vector2,
		accel: Vector2,
		delta: float,
		move_direction: Vector2
	) -> Vector2:
	var new_velocity := old_velocity

	new_velocity += move_direction * accel * delta
	new_velocity.x = clamp(new_velocity.x, -max_speed.x, max_speed.x)

	if new_velocity.y > max_speed.y:
		new_velocity.y = max_speed.y

	return new_velocity
