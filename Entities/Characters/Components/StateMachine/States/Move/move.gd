extends State

@export var idle_state: State


func process_physics(_delta: float) -> State:
	var movement = director.movement_vector * subject.speed
	subject.animation_player.set_facing(director.movement_vector)
	subject.animation_player.play_with_facing(animation_name)
	if movement == Vector2.ZERO:
		return idle_state
	subject.velocity = movement
	subject.move_and_slide()
	return null
