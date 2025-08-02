extends Node

@export var rope_scene: PackedScene
@export var red_cowboy: Node2D
@export var blue_cowboy: Node2D

@onready var linked_ropes: Array = []

signal loop_scored


func make_rope(endpoint_one: Node2D, endpoint_two: Node2D) -> Rope:
	var new_rope = rope_scene.instantiate()
	new_rope.endpoint_one = endpoint_one
	new_rope.endpoint_two = endpoint_two
	add_child(new_rope)
	return new_rope


func cleanup_ropes() -> void:
	for child in get_children():
		if is_instance_of(child, Rope) and not child.is_valid():
			child.queue_free()
	linked_ropes = linked_ropes.filter(func(lr): 
		return lr[0].is_valid() and lr[1].is_valid()
	)


func _process(_delta: float) -> void:
	var ropes = get_children().filter(func(child): 
		return is_instance_of(child, Rope) and is_instance_valid(child)
	)
	for i in ropes.size():
		for j in range(i+1, ropes.size()):
			if ropes[i].is_valid() and ropes[j].is_valid():
				var line1 = ropes[i].get_line_segment()
				var line2 = ropes[j].get_line_segment()
				var intersection = find_intersection(line1, line2)
				if intersection != Vector2.INF:
					var loop = find_loop(intersection, ropes[i], ropes[j])
					loop_scored.emit(loop)
					call_deferred("reset_ropes")



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
	if 0.1 < a and a <= 0.9 and 0.1 < b and b <= 0.9:
		var px = x1 + a * (x2 - x1)
		var py = y1 + a * (y2 - y1)
		print("======")
		print(line1)
		print(line2)
		print("a: %f, b: %f" % [a, b])
		print(Vector2(px, py))
		return Vector2(px, py)
	else:
		return Vector2.INF # if b == 0, the lines are parallel. if a == 0 and b == 0, colinear
	

func reset_ropes():
	for child in get_children():
		if (is_instance_of(child, Rope)):
			child.queue_free()
	linked_ropes = []
	make_rope(red_cowboy, blue_cowboy)	


func find_loop(intersection: Vector2, rope1: Rope, rope2: Rope) -> Array:
	var all_ropes = get_children()#.filter(func(child): is_instance_of(child, Rope))
	var all_nodes = []
	for rope in all_ropes:
		var p = rope.endpoint_one.global_position
		if not all_nodes.has(p):
			all_nodes.append(p)
		var q = rope.endpoint_two.global_position
		if not all_nodes.has(q):
			all_nodes.append(q)
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

	for row in adjacency_matrix:
		print(row)
	for rope in all_ropes:
		rope.print()

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
