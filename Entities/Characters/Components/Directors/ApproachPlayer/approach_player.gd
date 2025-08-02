class_name ApproachPlayer extends MeanderDirector

@export var chase_distance: int
@export var attack_distance: int


func _physics_process(_delta: float) -> void:
	var red_distance = subject.global_position.distance_to(Global.arrow_cowboy_location)
	var blue_distance = subject.global_position.distance_to(Global.wasd_cowboy_location)
	var closest_cowboy = min(red_distance, blue_distance)
	if red_distance == closest_cowboy and red_distance <= chase_distance:
		movement_vector = (Global.arrow_cowboy_location - subject.global_position).normalized()
	elif blue_distance == closest_cowboy and blue_distance <= chase_distance: 
		movement_vector = (Global.wasd_cowboy_location - subject.global_position).normalized()
	should_attack = closest_cowboy <= attack_distance
