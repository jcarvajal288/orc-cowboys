extends Node2D

@export var score_tracker: ScoreTracker

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()
