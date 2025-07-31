extends Node

@export var rope_scene: PackedScene


func _ready() -> void:
	for child in get_children():
		if child is Rope:
			child.rope_bent.connect(bend_rope)


func bend_rope(rope: Rope, bend_point: RopeSnapPoint) -> void:
	if not is_instance_valid(rope):
		return
	var rope1 = rope_scene.instantiate()
	rope1.endpoint_one = rope.endpoint_one
	rope1.endpoint_two = bend_point
	rope1.rope_bent.connect(bend_rope)

	var rope2 = rope_scene.instantiate()
	rope2.endpoint_one = bend_point
	rope2.endpoint_two = rope.endpoint_two
	rope2.rope_bent.connect(bend_rope)

	add_child(rope1)
	add_child(rope2)
	rope.queue_free()
