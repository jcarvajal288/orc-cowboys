extends Node

@export var rope_scene: PackedScene

@onready var linked_ropes: Array = []


func _ready() -> void:
	for child in get_children():
		if child is Rope:
			child.rope_bent.connect(bend_rope)


func bend_rope(old_rope: Rope, bend_point: RopeSnapPoint) -> void:
	if not is_instance_valid(old_rope):
		return
	var rope1 = make_rope(old_rope.endpoint_one, bend_point.rope_anchor_point)
	var rope2 = make_rope(bend_point.rope_anchor_point, old_rope.endpoint_two)
	link_new_ropes(old_rope, rope1, rope2, bend_point)
	delete_rope(old_rope)


func link_new_ropes(old_rope: Rope, rope1: Rope, rope2: Rope, bend_point: RopeSnapPoint) -> void:
	linked_ropes = linked_ropes.map(func(linked_rope: Array):
		if (linked_rope[0] == old_rope):
			return [rope2, linked_rope[1], linked_rope[2]]
		elif (linked_rope[1] == old_rope):
			return [linked_rope[0], rope1, linked_rope[2]]
		else:
			return linked_rope
	)
	linked_ropes = linked_ropes.filter(func(linked_rope): 
		return not linked_rope.has(old_rope)
	)
	linked_ropes.append([rope1, rope2, bend_point.center_point])


func delete_rope(rope: Rope) -> void:
	rope.rope_bent.disconnect(bend_rope)
	rope.queue_free()


func make_rope(endpoint_one: Node2D, endpoint_two: Node2D) -> Rope:
	var new_rope = rope_scene.instantiate()
	new_rope.endpoint_one = endpoint_one
	new_rope.endpoint_two = endpoint_two
	new_rope.rope_bent.connect(bend_rope)
	add_child(new_rope)
	return new_rope


func _physics_process(_delta: float) -> void:
	for linked_rope in linked_ropes:
		if has_unwound(linked_rope):
			unwind_ropes(linked_rope)
	var ropes = get_children().filter(func(child): return is_instance_of(child, Rope))
	# print("======")
	# print(ropes.size())
	for i in ropes.size():
		for j in range(i+1, ropes.size()):
			# print("%d,%d" % [i, j])
			var rope1 = ropes[i]
			var rope2 = ropes[j]
			if (do_segments_intersect(rope1.get_line_segment(), rope2.get_line_segment())):
				print("intersection found")


func has_unwound(linked_rope: Array) -> bool:
	var rope1: Rope = linked_rope[0]
	var rope2: Rope = linked_rope[1]
	var center_point: Vector2 = linked_rope[2]
	var endpoints: Array[Vector2] = [
		rope1.endpoint_one.global_position,
		rope1.endpoint_two.global_position,
		rope2.endpoint_one.global_position,
		rope2.endpoint_two.global_position,
	]
	var common_point = find_linked_rope_common_point(endpoints)
	var center_line: Array[Vector2] = [common_point, center_point]
	var rope_line: Array[Vector2] = endpoints.filter(func(endpoint): return endpoint != common_point)
	# the two ropes have unwound from their anchor point if the line segment from the common
	# point to the center point and the one from the far rope endpoints do not intersect
	return not does_line_intersect_ray(rope_line, center_line)


func find_linked_rope_common_point(endpoints: Array[Vector2]) -> Vector2:
	for i in endpoints.size():
		if endpoints.slice(i+1, -1).has(endpoints[i]):
			return endpoints[i]
	return endpoints[0]


func does_line_intersect_ray(line: Array[Vector2], ray: Array[Vector2]) -> bool:
	# taken from here: https://stackoverflow.com/questions/14307158/how-do-you-check-for-intersection-between-a-line-segment-and-a-line-ray-emanatin
	if (line.size() != 2 or ray.size() != 2):
		return false
	var v1 = ray[0] - line[0]
	var v2 = line[1] - line[0]
	var rayDirection = ray[1] - ray[0]
	var v3 = Vector2(-rayDirection.y, rayDirection.x)

	var dot = v2.dot(v3)
	if (abs(dot) < 0.000001):
		return false
	
	var t1 = v2.cross(v1) / dot
	var t2 = v1.dot(v3) / dot

	return (t1 >= 0.0 and (t2 >= 0.0 and t2 <= 1.0))


func do_segments_intersect(line1: Array[Vector2], line2: Array[Vector2]) -> bool:
	var are_counterclockwise = func(i: Vector2, j: Vector2, k: Vector2) -> bool:
		return (k.y - i.y) * (j.x - i.x) > (j.y - i.y) * (k.x - i.x)
	var a = line1[0]
	var b = line1[1]
	var c = line2[0]
	var d = line2[1]
	# check for connected lines
	var points = [a, b, c, d]
	for i in points.size():
		for j in range(i+1, points.size()):
			if (points[i] == points[j]):
				return false
	return (
		are_counterclockwise.call(a,c,d) !=
		are_counterclockwise.call(b,c,d) and
		are_counterclockwise.call(a,b,c) !=
		are_counterclockwise.call(a,b,d)
	)



func unwind_ropes(linked_rope: Array) -> void:
	var rope1: Rope = linked_rope[0]
	var rope2: Rope = linked_rope[1]
	var new_rope = null
	if (rope1.endpoint_one.global_position == rope2.endpoint_one.global_position):
		new_rope = make_rope(rope1.endpoint_two, rope2.endpoint_two)
	elif (rope1.endpoint_one.global_position == rope2.endpoint_two.global_position):
		new_rope = make_rope(rope1.endpoint_two, rope2.endpoint_one)
	elif (rope1.endpoint_two.global_position == rope2.endpoint_one.global_position):
		new_rope = make_rope(rope1.endpoint_one, rope2.endpoint_two)
	else:
		new_rope = make_rope(rope1.endpoint_one, rope2.endpoint_one)
	# remove the old linked_rope and link the ropes that it was touching before
	linked_ropes = linked_ropes.filter(func(lr): 
		return not lr == linked_rope
	).map(func(lr):
		return lr.map(func(r):
			if (is_instance_of(r, Rope) and (r == rope1 or r == rope2)):
				return new_rope
			else:
				return r
		)
	)
	delete_rope(rope1)
	delete_rope(rope2)
