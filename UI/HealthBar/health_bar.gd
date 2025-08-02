extends Node2D

@export var health: Health
@export var is_red: bool
@export var heart_scene: PackedScene

func _ready() -> void:
	health.took_damage.connect(change_health_bar)
	change_health_bar()


func change_health_bar() -> void:
	var hearts = get_children()
	for heart in hearts:
		heart.set_empty()
	for i in range(health.current_health):
		hearts[i].set_color(is_red)