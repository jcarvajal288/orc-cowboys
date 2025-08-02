extends Node

@export var arrow_cowboy: Cowboy
@export var wasd_cowboy: Cowboy
@export var barrel_scene: PackedScene
@export var rope_scene: PackedScene
@export var stationary_rope_scene: PackedScene
@export var barrel_tracker: BarrelTracker

signal loop_scored

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed('wasd_barrel'):
		place_barrel(wasd_cowboy)
	elif Input.is_action_just_pressed('arrow_barrel'):
		place_barrel(arrow_cowboy)
	affix_stationary_ropes()
	look_for_rope_intersection()


func get_all_ropes() -> Array:
	return $Ropes.get_children().filter(func(child): 
		return is_instance_of(child, Rope) and is_instance_valid(child)
	)


func get_all_barrels() -> Array:
	return $Barrels.get_children().filter(func(child): 
		return is_instance_of(child, Barrel) and is_instance_valid(child)
	)


func place_barrel(cowboy: Cowboy) -> void:
	if barrel_tracker.out_of_barrels():
		return
	var barrel = barrel_scene.instantiate()
	var rope: Rope = rope_scene.instantiate()
	barrel.position = cowboy.global_position
	switch_out_ropes(cowboy, rope, barrel)
	$Barrels.add_child(barrel)
	$Ropes.add_child(rope)
	barrel_tracker.subtract_barrel()
	$PlaceBarrelSFX.play()
	


func affix_stationary_ropes() -> void:
	for rope in get_all_ropes():
		if (not rope is StationaryRope and 
			rope.endpoint_one is Barrel and 
			rope.endpoint_two is Barrel):
			replace_with_stationary_rope(rope)
			


func switch_out_ropes(cowboy: Cowboy, new_rope: Rope, barrel: Barrel) -> void:
	for old_rope in $Ropes.get_children():
		if old_rope is Rope:
			if old_rope.endpoint_one == cowboy:
				old_rope.endpoint_one = barrel	
			elif old_rope.endpoint_two == cowboy:
				old_rope.endpoint_two = barrel	
	new_rope.endpoint_one = barrel
	new_rope.endpoint_two = cowboy


func replace_with_stationary_rope(rope: Rope):
	var stationary_rope: StationaryRope = stationary_rope_scene.instantiate()
	stationary_rope.endpoint_one = rope.endpoint_one
	stationary_rope.endpoint_two = rope.endpoint_two
	$Ropes.add_child(stationary_rope)
	rope.queue_free()


func ropes_are_linked(rope1: Rope, rope2: Rope) -> bool:
	return (
		rope1.endpoint_one == rope2.endpoint_one or
		rope1.endpoint_one == rope2.endpoint_two or
		rope1.endpoint_two == rope2.endpoint_one or
		rope1.endpoint_two == rope2.endpoint_two 
	)


func look_for_rope_intersection() -> void:
	var ropes = get_all_ropes()
	for i in ropes.size():
		for j in range(i+1, ropes.size()):
			if ropes_are_linked(ropes[i], ropes[j]):
				continue
			elif ropes[i].is_valid() and ropes[j].is_valid():
				var line1 = ropes[i].get_line_segment()
				var line2 = ropes[j].get_line_segment()
				var intersection = find_intersection(line1, line2)
				if intersection != Vector2.INF:
					var loop = find_loop(intersection, ropes[i], ropes[j])
					loop_scored.emit(loop)
					call_deferred("reset_state")


func reset_state():
	for rope in get_all_ropes():
		rope.queue_free()
	for barrel in get_all_barrels():
		barrel.queue_free()
	var rope = rope_scene.instantiate()
	rope.endpoint_one = wasd_cowboy
	rope.endpoint_two = arrow_cowboy
	$Ropes.add_child(rope)
	barrel_tracker.reset()


func find_intersection(line1: Array[Vector2], line2: Array[Vector2]) -> Vector2:
	# taken from https://www.youtube.com/watch?v=bvlIYX9cgls
	var x1 = line1[0].x
	var y1 = line1[0].y
	var x2 = line1[1].x
	var y2 = line1[1].y
	var x3 = line2[0].x
	var y3 = line2[0].y
	var x4 = line2[1].x
	var y4 = line2[1].y
	var a = (((x4 - x3) * (y3 - y1)) - ((y4 - y3) * (x3 - x1))) / (((x4 - x3) * (y2 - y1)) - ((y4 - y3) * (x2 - x1)))
	var b = (((x2 - x1) * (y3 - y1)) - ((y2 - y1) * (x3 - x1))) / (((x4 - x3) * (y2 - y1)) - ((y4 - y3) * (x2 - x1)))
	if 0 < a and a <= 1 and 0 < b and b <= 1:
		var px = x1 + a * (x2 - x1)
		var py = y1 + a * (y2 - y1)
		return Vector2(px, py)
	else:
		return Vector2.INF # if b == 0, the lines are parallel. if a == 0 and b == 0, colinear



func find_loop(intersection: Vector2, rope1: Rope, rope2: Rope) -> Array:
	var all_ropes = get_all_ropes()
	var all_nodes = get_all_barrels().map(func(b): return b.global_position)
	all_nodes.append(intersection)

	var adjacency_matrix = Array()
	adjacency_matrix.resize(all_nodes.size())
	for i in range(adjacency_matrix.size()):
		adjacency_matrix[i] = Array()
		adjacency_matrix[i].resize(all_nodes.size())
		for j in range(adjacency_matrix[i].size()):
			adjacency_matrix[i][j] = false

	for rope in all_ropes:
		var index1 = all_nodes.find(rope.endpoint_one.global_position)
		var index2 = all_nodes.find(rope.endpoint_two.global_position)
		if (rope == rope1 or rope == rope2): # attach these to the intersection point
			adjacency_matrix[index1][-1] = true
			adjacency_matrix[index2][-1] = true
			adjacency_matrix[-1][index1] = true
			adjacency_matrix[-1][index2] = true
		else:
			adjacency_matrix[index1][index2] = true
			adjacency_matrix[index2][index1] = true

	# for row in adjacency_matrix:
	# 	print(row)
	# for rope in all_ropes:
	# 	rope.print()

	var cycles = find_all_cycles(adjacency_matrix)
	var loop = cycles[0].map(func(i): return all_nodes[i])
	return loop


func find_all_cycles(adjacency_matrix: Array) -> Array:
	# took from here: https://tech-champion.com/programming/python-programming/python-cycle-detection-in-adjacency-matrix-finding-all-simple-cycles/
	var num_nodes = adjacency_matrix.size()
	var all_cycles = Array()

	var dfs := func(node, path, visited, dfs_func) -> void:
		visited[node] = true
		path.append(node)
		for neighbor in range(num_nodes):
			if (adjacency_matrix[node][neighbor]):
				if neighbor == path[0] and path.size() > 2:
					all_cycles.append(path.duplicate(true))
				elif not visited[neighbor]:
					dfs_func.call(neighbor, path, visited.duplicate(true), dfs_func)
	
	for start_node in range(num_nodes):
		var visited = Array()
		visited.resize(num_nodes)
		for i in range(visited.size()):
			visited[i] = false
			dfs.call(start_node, Array(), visited, dfs)
	
	return all_cycles
