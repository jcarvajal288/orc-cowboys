class_name Rope extends Node2D

@export var endpoint_one: Node2D 
@export var endpoint_two: Node2D 

@onready var area_collision_shape = $TextureRect/Area2D/CollisionShape2D



func _ready() -> void:
	$TextureRect.z_index = Global.RenderOrder.ROPE
	$TextureRect.set_stretch_mode(TextureRect.StretchMode.STRETCH_TILE)
	$TextureRect.set_expand_mode(TextureRect.ExpandMode.EXPAND_FIT_HEIGHT_PROPORTIONAL)


func _process(_delta: float) -> void:
	if not (is_instance_valid(endpoint_one) and is_instance_valid(endpoint_two)):
		return
	var direction = endpoint_two.global_position - endpoint_one.global_position
	var distance = direction.length()
	var angle = direction.angle() - PI / 2.0
	position = endpoint_one.global_position
	$TextureRect.rotation = angle
	$TextureRect.size = Vector2(3, distance)
	area_collision_shape.shape.size = $TextureRect.size
	area_collision_shape.position = $TextureRect.size / 2.0


func get_line_segment() -> Array[Vector2]:
	return [endpoint_one.global_position, endpoint_two.global_position]


func is_valid() -> bool:
	return is_instance_valid(endpoint_one) and is_instance_valid(endpoint_two)

func print() -> void:
	print("(%f,%f) - (%f,%f)" % [
		endpoint_one.global_position.x,
		endpoint_one.global_position.y,
		endpoint_two.global_position.x,
		endpoint_two.global_position.y,
	])
