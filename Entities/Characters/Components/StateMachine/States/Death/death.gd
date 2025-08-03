extends State

@export var state_machine: StateMachine
@export var death_sound: AudioStreamPlayer2D

func enter() -> void:
	super()
	subject.velocity = Vector2.ZERO


func _on_death() -> void:
	state_machine.change_state(self)
	death_sound.play()


func _on_animation_player_animation_finished(anim_name:StringName) -> void:
	if anim_name == self.animation_name:
		Global.game_over.emit()

	
