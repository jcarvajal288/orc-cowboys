extends Node2D

@export var game_over_screen_scene: PackedScene
@export var score_tracker: ScoreTracker

func _ready() -> void:
	Global.game_over.connect(_on_game_over)


func _on_game_over():
	var game_over_screen = game_over_screen_scene.instantiate()
	game_over_screen.set_score(score_tracker.score)
	add_child(game_over_screen)
