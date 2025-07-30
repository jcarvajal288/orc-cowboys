extends Node

enum RenderOrder {
	FLOOR = 0,
	ROPE = 2,
	PLAYER = 5,
	WALL = 10
}

enum CollisionLayer {
	WALL = 1,
	ROPE_SNAP_POINT = 2,
}