extends Node2D

@export var endpoint_one: Node2D 
@export var endpoint_two: Node2D 


func _ready() -> void:
	$TextureRect.z_index = Global.RenderOrder.ROPE
	$TextureRect.set_stretch_mode(TextureRect.StretchMode.STRETCH_TILE)
	$TextureRect.set_expand_mode(TextureRect.ExpandMode.EXPAND_FIT_HEIGHT_PROPORTIONAL)


func _process(_delta: float) -> void:
	var direction = endpoint_two.position - endpoint_one.position
	var distance = direction.length()
	var angle = direction.angle() - PI / 2.0
	position = endpoint_one.position
	$TextureRect.rotation = angle
	$TextureRect.size = Vector2(3, distance)
