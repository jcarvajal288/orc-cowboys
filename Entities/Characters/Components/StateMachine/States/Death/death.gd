extends State

@export var state_machine: StateMachine

func enter() -> void:
	super()
	subject.velocity = Vector2.ZERO


func _on_hit(_hitbox: Hitbox) -> void:
	state_machine.change_state(self)


func _on_animation_player_animation_finished(anim_name:StringName) -> void:
	if anim_name == self.animation_name:
		Global.game_over.emit()

	
