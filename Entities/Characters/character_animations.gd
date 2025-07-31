extends AnimationPlayer

var facing = "DownRight"

func play_with_facing(anim_name: String) -> void:
	self.play(anim_name + facing)

func set_facing(direction: Vector2):
	if direction.x > 0:
		if direction.y > 0:
			facing = "DownRight"
		else:
			facing = "UpRight"
	elif direction.x < 0:
		if direction.y > 0:
			facing = "DownLeft"
		else:
			facing = "UpLeft"
