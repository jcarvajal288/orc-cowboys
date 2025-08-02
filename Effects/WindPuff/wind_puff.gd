extends Node2D

func _ready() -> void:
	z_index = Global.RenderOrder.EFFECT
	$AnimatedSprite2D.play()


func _on_animated_sprite_2d_animation_finished() -> void:
	queue_free()
