extends Node

@export var barrel_scene: PackedScene

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed('wasd_barrel'):
		print("wasd_barrel")
		place_barrel(Global.blue_cowboy_location)
	elif Input.is_action_just_pressed('arrow_barrel'):
		print("arrow_barrel")
		place_barrel(Global.red_cowboy_location)


func place_barrel(location: Vector2) -> void:
	var barrel = barrel_scene.instantiate()
	barrel.position = location
	add_child(barrel)
