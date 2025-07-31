class_name RopeSnapPoint extends Area2D

var center_point: Vector2

@onready var rope_anchor_point = $RopeAnchorPoint

func _ready() -> void:
	set_collision_layer_value(Global.CollisionLayer.ROPE_SNAP_POINT, true)
	set_collision_mask_value(Global.CollisionLayer.ROPE_SNAP_POINT, true)
