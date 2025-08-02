extends State

@export var state_machine: StateMachine
@export var idle_state: State
@export var sound_effect: AudioStreamPlayer2D

func _on_hit(_area: Hitbox) -> void:
	state_machine.change_state(self)
	sound_effect.play()


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name.begins_with(self.animation_name):
		state_machine.change_state(idle_state)

	

func process_physics(_delta: float) -> State:
	var movement = director.movement_vector * subject.speed
	subject.animation_player.set_facing(director.movement_vector)
	subject.animation_player.play_with_facing(animation_name)
	subject.velocity = movement
	subject.move_and_slide()
	return null
