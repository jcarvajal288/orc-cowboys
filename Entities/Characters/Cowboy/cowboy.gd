class_name Cowboy extends CharacterBody2D

@export var sprite_texture: Texture2D

@onready var animation_player = $AnimationPlayer

var speed = 75

func _ready() -> void:
	$Sprite2D.z_index = Global.RenderOrder.PLAYER
	if sprite_texture:
		$Sprite2D.texture = sprite_texture
	$StateMachine.init(self)

func _physics_process(delta: float) -> void:
	$StateMachine.process_physics(delta)


func _unhandled_input(event: InputEvent) -> void:
	$StateMachine.process_input(event)


func _process(delta: float) -> void:
	$StateMachine.process_frame(delta)
