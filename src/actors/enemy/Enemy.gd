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
	if is_on_floor() and is_on_wall():
		_velocity.x *= -1
		$Sprite.flip_h = not $Sprite.flip_h
	_velocity.y = move_and_slide(_velocity, FLOOR_NORMAL).y


func kill() -> void:
	_velocity = Vector2.ZERO
	$AnimationPlayer.stop()
	emit_signal("killed", score)
	queue_free()


func get_velocity() -> Vector2:
	return _velocity


func _on_VisibilityEnabler2D_screen_exited() -> void:
	queue_free()
