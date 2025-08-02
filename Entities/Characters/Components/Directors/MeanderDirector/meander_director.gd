class_name MeanderDirector extends Director

func _ready() -> void:
	$Timer.timeout.connect(change_activity)
	$Timer.start()


func change_activity() -> void:
	if (Global.rng.randi() % 2 == 0):
		movement_vector = get_direction()
	else:
		movement_vector = Vector2.ZERO
	$Timer.start()


func get_direction() -> Vector2:
	if subject is Critter and subject.is_outside_spawn_area:
		return (Global.get_random_point_in_spawn_area() - subject.global_position).normalized()
	else: 
		var random_x = Global.rng.randf_range(-1, 1)
		var random_y = Global.rng.randf_range(-1, 1)
		var random_direction = Vector2(random_x, random_y).normalized()
		return  random_direction
