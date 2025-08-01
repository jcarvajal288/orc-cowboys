class_name ApproachPlayer extends Director

@export var chase_distance: int

func _physics_process(_delta: float) -> void:
	var red_distance = subject.global_position.distance_to(Global.red_cowboy_location)
	var blue_distance = subject.global_position.distance_to(Global.blue_cowboy_location)
	var closest_cowboy = min(red_distance, blue_distance)
	if red_distance == closest_cowboy and red_distance <= chase_distance:
		movement_vector = (Global.red_cowboy_location - subject.global_position).normalized()
	elif blue_distance == closest_cowboy and blue_distance <= chase_distance: 
		movement_vector = (Global.blue_cowboy_location - subject.global_position).normalized()
	else:
		movement_vector = Vector2.ZERO
