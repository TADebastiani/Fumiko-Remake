extends KinematicBody2D

signal killed

export var speed = Vector2(100.0, 350.0)
export var gravity = 1000.0
export var score = 5

const FLOOR_NORMAL = Vector2.UP

var _velocity = Vector2.ZERO

func _ready() -> void:
	set_physics_process(false)
	_velocity.x =  -speed.x
	$AnimationPlayer.play("walk")


func _physics_process(delta: float) -> void:
	_velocity.y += gravity * delta
	_velocity.y = move_and_slide(_velocity, FLOOR_NORMAL).y
	if is_on_wall() or is_on_gap():
		flip()


func is_on_gap() -> bool:
	return not $Body/RayCast2D.is_colliding()


func flip() -> void:
	_velocity.x *= -1
	$Body.scale.x *= -1


func kill() -> void:
	_velocity = Vector2.ZERO
	$AnimationPlayer.stop()
	emit_signal("killed", self)
	queue_free()


func get_velocity() -> Vector2:
	return _velocity


func get_position() -> Vector2:
	return Vector2(
		int(global_position.x),
		int(global_position.y)
	)


func _on_VisibilityEnabler2D_screen_exited() -> void:
#	queue_free()
	kill()
