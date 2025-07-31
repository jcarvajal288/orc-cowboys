extends Node

@export var rope_scene: PackedScene


func _ready() -> void:
	for child in get_children():
		if child is Rope:
			child.rope_bent.connect(bend_rope)


func bend_rope(rope: Rope, bend_point: RopeSnapPoint) -> void:
	if not is_instance_valid(rope):
		return
	make_rope(rope.endpoint_one, bend_point)
	make_rope(bend_point, rope.endpoint_two)
	rope.rope_bent.disconnect(bend_rope)
	rope.queue_free()


func make_rope(endpoint_one: Node2D, endpoint_two: Node2D) -> void:
	var new_rope = rope_scene.instantiate()
	new_rope.endpoint_one = endpoint_one
	new_rope.endpoint_two = endpoint_two
	new_rope.rope_bent.connect(bend_rope)
	add_child(new_rope)
