extends State

export var hurt_time: float = 1

onready var move_state: State = get_node("../Move")

func enter(_msg: Dictionary = {}) -> void:
	owner.hurt_area.set_deferred("monitoring", false)
	owner.animation_player.play("hurt")
	$HurtTime.start(hurt_time)
	$Tween.interpolate_method(self, "change_opacity", 0.0, 1.0, hurt_time, Tween.TRANS_BOUNCE, Tween.EASE_OUT_IN)
	$Tween.start()


func exit() -> void:
	owner.hurt_area.set_deferred("monitoring", true)


func change_opacity(value):
	owner.sprite.modulate = Color(1, 1, 1, value)


func _on_HurtTime_timeout() -> void:
	_state_machine.transition_to(_state_machine.initial_state)
