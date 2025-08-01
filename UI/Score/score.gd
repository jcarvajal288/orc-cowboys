extends CanvasLayer

var score = 0


func _ready() -> void:
	$Label.text = "%d" % score


func change_score(amount: int) -> void:
	score += amount
	$Label.text = score
