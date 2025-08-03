extends Node2D

func _ready() -> void:
	$GameOverSound.play()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("reset"):
		Global.is_game_over = false
		get_tree().reload_current_scene()


func set_score(final_score: int) -> void:
	$CanvasLayer/ScoreLabel.text = "Final Score: %d" % final_score
