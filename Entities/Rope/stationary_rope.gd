class_name StationaryRope extends Rope


func _ready() -> void:
	super()
	collision_shape = $TextureRect/StaticBody2D/CollisionShape2D
	$TextureRect.modulate.a = 1.0
	$TextureRect/StaticBody2D.set_collision_mask_value(Global.CollisionLayer.STATIONARY_ROPE, true)
	