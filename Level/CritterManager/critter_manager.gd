extends Node2D

@export var pig_scene: PackedScene

@onready var time_elapsed = 0.0
@onready var max_critters = 8

func _ready() -> void:
	spawn_critters()


func _process(delta: float) -> void:
	time_elapsed += delta


func spawn_critters():
	var current_critters = $Critters.get_children().filter(func(child): 
		return child is Critter
	)
	var critters_to_spawn = max_critters - current_critters.size()
	for i in range(critters_to_spawn):
		spawn_pig()


func get_spawn_point() -> Vector2:
	var spawn_area = $SpawnArea/CollisionShape2D.shape.get_rect()
	var random_x = Global.rng.randf_range(spawn_area.position.x, spawn_area.end.x)
	var random_y = Global.rng.randf_range(spawn_area.position.y, spawn_area.end.y)
	var spawn_area_position = $SpawnArea/CollisionShape2D.global_position
	return Vector2(
		spawn_area_position.x + random_x, 
		spawn_area_position.y + random_y
	)


func spawn_pig():
	var pig: Pig = pig_scene.instantiate()
	var spawn_point = get_spawn_point()
	pig.global_position = spawn_point
	$Critters.add_child(pig)


func _on_scoring_finished() -> void:
	spawn_critters()
