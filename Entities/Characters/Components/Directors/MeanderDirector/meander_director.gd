class_name MeanderDirector extends Director

func _ready() -> void:
	$Timer.timeout.connect(change_activity)
	$Timer.start()


func change_activity() -> void:
	if (Global.rng.randi() % 2 == 0):
		var random_x = Global.rng.randf_range(-1, 1)
		var random_y = Global.rng.randf_range(-1, 1)
		var random_direction = Vector2(random_x, random_y).normalized()
		movement_vector = random_direction
	else:
		movement_vector = Vector2.ZERO
	$Timer.start()
