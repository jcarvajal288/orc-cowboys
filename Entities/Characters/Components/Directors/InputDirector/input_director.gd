class_name InputDirector extends Director

@export var wasd_movement: bool

func bind_8_way(input_direction: Vector2) -> Vector2:
	return Vector2(
		snapped(input_direction.x, 0.5),
		snapped(input_direction.y, 0.5)
	).normalized()


func _physics_process(_delta: float) -> void:
	if wasd_movement:
		movement_vector = bind_8_way(Input.get_vector("wasd_left", "wasd_right", "wasd_up", "wasd_down"))
	else:
		movement_vector = bind_8_way(Input.get_vector("arrow_left", "arrow_right", "arrow_up", "arrow_down"))