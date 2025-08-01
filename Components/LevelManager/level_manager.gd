extends Node


func _ready() -> void:
	$ScoreArea.body_entered.connect(score_critter)
	disable_score_area(true)


func disable_score_area(b: bool) -> void:
	$ScoreArea/CollisionPolygon2D.disabled = b
	$ScoreArea/LoopPolygon.visible = !b



func score_loop(loop: Array) -> void:
	print("score loop")
	$ScoreArea/LoopPolygon.polygon = loop
	$ScoreArea/CollisionPolygon2D.polygon = loop
	disable_score_area(false)
	$ScoreTimer.start(0.1)
	await $ScoreTimer.timeout
	disable_score_area(true)


func score_critter(body: Node2D) -> void:
	if is_instance_of(body, Critter):
		print("scored " + body.name)
		body.queue_free()
