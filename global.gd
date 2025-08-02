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
}

var arrow_cowboy_location = Vector2.ZERO
var wasd_cowboy_location = Vector2.ZERO
