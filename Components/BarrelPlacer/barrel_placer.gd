extends Node

@export var red_cowboy: Cowboy
@export var blue_cowboy: Cowboy
@export var barrel_scene: PackedScene
@export var rope_scene: PackedScene

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed('wasd_barrel'):
		place_barrel(blue_cowboy)
	elif Input.is_action_just_pressed('arrow_barrel'):
		place_barrel(red_cowboy)


func place_barrel(cowboy: Cowboy) -> void:
	var barrel = barrel_scene.instantiate()
	var rope: Rope = rope_scene.instantiate()
	barrel.position = cowboy.global_position
	switch_out_ropes(cowboy, rope, barrel)
	add_child(barrel)
	add_child(rope)


func switch_out_ropes(cowboy: Cowboy, new_rope: Rope, barrel: Barrel) -> void:
	for old_rope in get_children():
		if old_rope is Rope:
			if old_rope.endpoint_one == cowboy:
				old_rope.endpoint_one = barrel	
			elif old_rope.endpoint_two == cowboy:
				old_rope.endpoint_two = barrel	
	new_rope.endpoint_one = barrel
	new_rope.endpoint_two = cowboy
