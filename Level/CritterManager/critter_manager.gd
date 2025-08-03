extends Node2D

@export var pig_scene: PackedScene
@export var lion_scene: PackedScene
@export var wind_puff_scene: PackedScene

@onready var time_elapsed = 0.0
@onready var max_pigs = 6
@onready var max_lions = 0
@onready var pig_spawn_rate = 20
@onready var lion_spawn_rate = 15

func _ready() -> void:
	Global.spawn_area_position = $SpawnArea/CollisionShape2D.global_position
	Global.spawn_area_rect = $SpawnArea/CollisionShape2D.shape.get_rect()
	$SpawnArea.set_collision_mask_value(Global.CollisionLayer.SPAWN_AREA, true)
	# spawn_critters()


func _process(delta: float) -> void:
	time_elapsed += delta
	update_critter_counts()


func update_critter_counts():
	max_lions = min(int(floor(time_elapsed)) / lion_spawn_rate, 4)
	max_pigs = 6 + int(floor(time_elapsed)) / pig_spawn_rate


func spawn_critters():
	var current_pigs = $Critters.get_children().filter(func(child): 
		return child is Pig
	)
	var pigs_to_spawn = max_pigs - current_pigs.size()
	for i in range(pigs_to_spawn):
		spawn_pig()
	spawn_lions()



func spawn_pig():
	var pig: Pig = pig_scene.instantiate()
	var spawn_point = Global.get_random_point_in_spawn_area()
	pig.global_position = spawn_point
	$Critters.add_child(pig)
	$SpawnArea.body_exited.connect(pig.has_left_spawn_area)
	$SpawnArea.body_entered.connect(pig.has_entered_spawn_area)
	spawn_wind_puff(spawn_point)


func spawn_lions():
	var spawn_points = $LionSpawnPoints.get_children()
	spawn_points.shuffle()
	for i in range(min(max_lions, spawn_points.size())):
		spawn_lion(spawn_points[i].global_position)
		spawn_wind_puff(spawn_points[i].global_position)


func spawn_wind_puff(spawn_point: Vector2) -> void:
	var wind_puff = wind_puff_scene.instantiate()
	wind_puff.global_position = spawn_point
	add_child(wind_puff)


func spawn_lion(spawn_point: Vector2):
	var lion: Lion = lion_scene.instantiate()
	lion.global_position = spawn_point
	$Critters.add_child(lion)
	$SpawnArea.body_exited.connect(lion.has_left_spawn_area)
	$SpawnArea.body_entered.connect(lion.has_entered_spawn_area)


func _on_scoring_finished() -> void:
	pass
	# spawn_critters()
