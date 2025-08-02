class_name Health extends Node

@onready var max_health = 3
@onready var current_health = max_health

signal took_damage
signal died

func take_hit():
	if current_health <= 0:
		return
	current_health -= 1
	took_damage.emit()
	if current_health <= 0:
		print("Health: died")
		died.emit()