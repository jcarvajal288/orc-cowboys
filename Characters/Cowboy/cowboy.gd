extends CharacterBody2D

@onready var animation_player = $AnimationPlayer

func _ready() -> void:
	$StateMachine.init(self)