class_name Rope extends Node2D

@export var endpoint_one: Node2D 
@export var endpoint_two: Node2D 

@onready var collision_shape = $TextureRect/Area2D/CollisionShape2D

signal rope_bent


func _ready() -> void:
	$TextureRect.z_index = Global.RenderOrder.ROPE
	$TextureRect.set_stretch_mode(TextureRect.StretchMode.STRETCH_TILE)
	$TextureRect.set_expand_mode(TextureRect.ExpandMode.EXPAND_FIT_HEIGHT_PROPORTIONAL)
	$TextureRect/Area2D.area_entered.connect(_on_area_entered)
	$TextureRect/Area2D.set_collision_layer_value(Global.CollisionLayer.ROPE_SNAP_POINT, true)
	$TextureRect/Area2D.set_collision_mask_value(Global.CollisionLayer.ROPE_SNAP_POINT, true)


func _process(_delta: float) -> void:
	if not (is_instance_valid(endpoint_one) and is_instance_valid(endpoint_two)):
		return
	var direction = endpoint_two.global_position - endpoint_one.global_position
	var distance = direction.length()
	var angle = direction.angle() - PI / 2.0
	position = endpoint_one.global_position
	$TextureRect.rotation = angle
	$TextureRect.size = Vector2(3, distance)
	collision_shape.shape.size = $TextureRect.size
	collision_shape.position = $TextureRect.size / 2.0


func _on_area_entered(snap_point: RopeSnapPoint):
	# print("rope detected")
	var anchor_point = snap_point.rope_anchor_point
	if not (anchor_point == endpoint_one or anchor_point == endpoint_two):
		rope_bent.emit(self, snap_point)


func get_line_segment() -> Array[Vector2]:
	return [endpoint_one.global_position, endpoint_two.global_position]