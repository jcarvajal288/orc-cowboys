extends Node2D


func _ready() -> void:
	for child in get_children():
		if child is RopeSnapPoint:
			child.center_point = self.global_position