extends Node

var rng: RandomNumberGenerator

func _ready() -> void:
	rng = RandomNumberGenerator.new()

enum RenderOrder {
	FLOOR = 0,
	ROPE = 2,
	PLAYER = 5,
	WALL = 10
}

enum CollisionLayer {
	WALL = 1,
	ROPE = 2,
	SPAWN_AREA = 3,
	STATIONARY_ROPE = 4,
}

var arrow_cowboy_location = Vector2.ZERO
var wasd_cowboy_location = Vector2.ZERO
var spawn_area_position = Vector2.ZERO
var spawn_area_rect = null

signal game_over


func get_random_point_in_spawn_area() -> Vector2:
	var rect = spawn_area_rect
	var random_x = Global.rng.randf_range(rect.position.x, rect.end.x)
	var random_y = Global.rng.randf_range(rect.position.y, rect.end.y)
	return Vector2(
		spawn_area_position.x + random_x, 
		spawn_area_position.y + random_y
	)

