class_name Pig extends Critter

func _init() -> void:
	speed = 20
	score = 50


func _process(_delta: float) -> void:
	if Global.rng.randi() % 5000 == 0:
		play_sound()


func play_sound() -> void:
	var sounds = get_children().filter(func(child):
		return child is AudioStreamPlayer2D
	)
	sounds.shuffle()
	sounds[0].play()
