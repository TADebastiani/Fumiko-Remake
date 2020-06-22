extends KinematicBody2D

signal hurted(life)
signal dead

const FLOOR_NORMAL := Vector2.UP

onready var animation_player: AnimationPlayer = $AnimationPlayer
onready var hurt_area: Area2D = $HurtArea
onready var attack_area: Area2D = $ArtackArea
onready var camera: Camera2D = $Camera2D
onready var sprite: Sprite = $Sprite

var __life: int = 6

func reset_camera(screen_width, screen_height) -> void:
	camera.global_position.x = screen_width
	camera.limit_left = 0
	camera.limit_right = screen_height * 2


func flip(direction: float) -> void:
	if direction != 0:
		$Sprite.scale.x = direction
		$CollisionShape2D.scale.x = direction
		$ArtackArea.scale.x = direction


func _on_HurtArea_body_entered(body: Node) -> void:
	__life -= 1
	if __life == 0:
		emit_signal("dead")
		$StateMachine.transition_to("Dead")
	else:
		emit_signal("hurted", __life)
		$StateMachine.transition_to("Hurt")
