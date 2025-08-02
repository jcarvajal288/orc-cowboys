class_name Hurtbox extends Area2D

@export var subject: CharacterBody2D

signal on_hit


func _ready() -> void:
	area_entered.connect(_on_area_entered)


func _on_area_entered(hitbox: Hitbox) -> void:
	on_hit.emit(hitbox)
