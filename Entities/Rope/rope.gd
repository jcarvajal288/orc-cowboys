extends Node2D

@export var endpoint_one: Node2D 
@export var endpoint_two: Node2D 

@onready var collision_shape = $TextureRect/Area2D/CollisionShape2D


func _ready() -> void:
	$TextureRect.z_index = Global.RenderOrder.ROPE
	$TextureRect.set_stretch_mode(TextureRect.StretchMode.STRETCH_TILE)
	$TextureRect.set_expand_mode(TextureRect.ExpandMode.EXPAND_FIT_HEIGHT_PROPORTIONAL)
	$TextureRect/Area2D.area_entered.connect(_on_area_entered)
	$TextureRect/Area2D.set_collision_layer_value(Global.CollisionLayer.ROPE_SNAP_POINT, true)
	$TextureRect/Area2D.set_collision_mask_value(Global.CollisionLayer.ROPE_SNAP_POINT, true)


func _process(_delta: float) -> void:
	var direction = endpoint_two.position - endpoint_one.position
	var distance = direction.length()
	var angle = direction.angle() - PI / 2.0
	position = endpoint_one.position
	$TextureRect.rotation = angle
	$TextureRect.size = Vector2(3, distance)
	collision_shape.shape.size = $TextureRect.size
	collision_shape.position = $TextureRect.size / 2.0


func _on_area_entered(_area: Area2D):
	print("rope collided")
