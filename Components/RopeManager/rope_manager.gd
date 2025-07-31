extends Node

@export var rope_scene: PackedScene

@onready var linked_ropes: Array = []


func _ready() -> void:
	for child in get_children():
		if child is Rope:
			child.rope_bent.connect(bend_rope)


func bend_rope(rope: Rope, bend_point: RopeSnapPoint) -> void:
	print("bending rope")
	if not is_instance_valid(rope):
		return
	var rope1 = make_rope(rope.endpoint_one, bend_point.rope_anchor_point)
	var rope2 = make_rope(bend_point.rope_anchor_point, rope.endpoint_two)
	linked_ropes.append([rope1, rope2, bend_point.center_point])
	delete_rope(rope)


func delete_rope(rope: Rope) -> void:
	print("deleting rope")
	rope.rope_bent.disconnect(bend_rope)
	linked_ropes = linked_ropes.filter(func(linked_rope): 
		return not linked_rope.has(rope)
	)
	rope.queue_free()


func make_rope(endpoint_one: Node2D, endpoint_two: Node2D) -> Rope:
	print("making rope")
	var new_rope = rope_scene.instantiate()
	new_rope.endpoint_one = endpoint_one
	new_rope.endpoint_two = endpoint_two
	new_rope.rope_bent.connect(bend_rope)
	add_child(new_rope)
	return new_rope


func _physics_process(_delta: float) -> void:
	for linked_rope in linked_ropes:
		if has_unwound(linked_rope):
			#print("has unwound")
			unwind_ropes(linked_rope)


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
	# print("center line:")
	# print(center_line)
	# print("rope line:")
	# print(rope_line)
	return not do_lines_intersect(rope_line, center_line)

func find_linked_rope_common_point(endpoints: Array[Vector2]) -> Vector2:
	# print(endpoints)
	for i in endpoints.size():
		if endpoints.slice(i+1, -1).has(endpoints[i]):
			return endpoints[i]
	# print("no common point found!")
	return endpoints[0]


func do_lines_intersect(line: Array[Vector2], ray: Array[Vector2]) -> bool:
	# taken from here: https://stackoverflow.com/questions/14307158/how-do-you-check-for-intersection-between-a-line-segment-and-a-line-ray-emanatin
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


func unwind_ropes(linked_rope: Array) -> void:
	var rope1: Rope = linked_rope[0]
	var rope2: Rope = linked_rope[1]
	if (rope1.endpoint_one.global_position == rope2.endpoint_one.global_position):
		make_rope(rope1.endpoint_two, rope2.endpoint_two)
	elif (rope1.endpoint_one.global_position == rope2.endpoint_two.global_position):
		make_rope(rope1.endpoint_two, rope2.endpoint_one)
	elif (rope1.endpoint_two.global_position == rope2.endpoint_one.global_position):
		make_rope(rope1.endpoint_one, rope2.endpoint_two)
	else:
		make_rope(rope1.endpoint_one, rope2.endpoint_one)
	delete_rope(rope1)
	delete_rope(rope2)
