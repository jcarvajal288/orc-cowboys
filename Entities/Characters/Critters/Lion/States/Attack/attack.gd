extends State

@export var state_machine: StateMachine
@export var idle_state: State

func enter() -> void:
	super()
	subject.velocity = Vector2.ZERO


func _on_animation_player_animation_finished(anim_name:StringName) -> void:
	if anim_name.begins_with(self.animation_name):
		state_machine.change_state(idle_state)
