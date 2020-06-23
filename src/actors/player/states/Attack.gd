extends State


func enter(_msg: Dictionary = {}) -> void:
	owner.animation_player.connect("animation_finished", self, "_on_AnimationPlayer_animation_finished")
	owner.attack_area.connect("body_entered", self, "_on_AttackArea_body_entered")
	owner.attack_area.monitoring = true
	owner.animation_player.play("attack")


func exit() -> void:
	owner.animation_player.disconnect("animation_finished", self, "_on_AnimationPlayer_animation_finished")
	owner.attack_area.disconnect("body_entered", self, "_on_AttackArea_body_entered")
	owner.attack_area.monitoring = false


func _on_AnimationPlayer_animation_finished(_anim_name: String) -> void:
	_state_machine.transition_to(_state_machine.initial_state)


func _on_AttackArea_body_entered(body) -> void:
	body.kill()
