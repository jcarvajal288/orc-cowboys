extends Node2D

@export var pig_scene: PackedScene
@export var lion_scene: PackedScene

@onready var time_elapsed = 0.0
@onready var max_critters = 6

func _ready() -> void:
	Global.spawn_area_position = $SpawnArea/CollisionShape2D.global_position
	Global.spawn_area_rect = $SpawnArea/CollisionShape2D.shape.get_rect()
	$SpawnArea.set_collision_mask_value(Global.CollisionLayer.SPAWN_AREA, true)
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
	spawn_lions()



func spawn_pig():
	var pig: Pig = pig_scene.instantiate()
	var spawn_point = Global.get_random_point_in_spawn_area()
	pig.global_position = spawn_point
	$Critters.add_child(pig)
	$SpawnArea.body_exited.connect(pig.has_left_spawn_area)
	$SpawnArea.body_entered.connect(pig.has_entered_spawn_area)


func spawn_lions():
	var spawn_points = $LionSpawnPoints.get_children()
	spawn_points.shuffle()
	spawn_lion(spawn_points[0].global_position)
	spawn_lion(spawn_points[1].global_position)


func spawn_lion(spawn_point: Vector2):
	var lion: Lion = lion_scene.instantiate()
	lion.global_position = spawn_point
	$Critters.add_child(lion)
	$SpawnArea.body_exited.connect(lion.has_left_spawn_area)
	$SpawnArea.body_entered.connect(lion.has_entered_spawn_area)


func _on_scoring_finished() -> void:
	spawn_critters()
