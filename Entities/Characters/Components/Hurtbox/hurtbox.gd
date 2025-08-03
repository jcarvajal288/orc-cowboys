class_name Hurtbox extends Area2D

@export var health: Health

func _ready() -> void:
	area_entered.connect(_on_area_entered)


func _on_area_entered(area: Area2D) -> void:
	if area is Hitbox:
		health.take_hit()
