extends Area2D

func _ready() -> void:
	set_collision_layer_value(Global.CollisionLayer.ROPE_SNAP_POINT, true)
	set_collision_mask_value(Global.CollisionLayer.ROPE_SNAP_POINT, true)
