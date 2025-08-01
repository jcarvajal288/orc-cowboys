extends State

@export var move_state: State


func enter() -> void:
	super()
	subject.velocity = Vector2.ZERO


# having this as process_input caused a keyboard delay. check in zeldaclone
func process_physics(_delta: float) -> State:
	if director.movement_vector != Vector2.ZERO:
		return move_state
	return null