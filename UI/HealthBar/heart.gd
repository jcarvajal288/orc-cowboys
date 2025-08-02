class_name Heart extends Node2D

func set_empty():
	$Sprite2D.region_rect = Rect2(16.0, 0.0, 8.0, 8.0)

func set_color(is_red: bool):
	if is_red:
		$Sprite2D.region_rect = Rect2(0.0, 0.0, 8.0, 8.0)
	else:
		$Sprite2D.region_rect = Rect2(8.0, 0.0, 8.0, 8.0)
