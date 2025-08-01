class_name Critter extends CharacterBody2D

@onready var animation_player = $AnimationPlayer

var speed = 20

func _ready() -> void:
	$Sprite2D.z_index = Global.RenderOrder.PLAYER
	$StateMachine.init(self)

func _physics_process(delta: float) -> void:
	$StateMachine.process_physics(delta)


func _unhandled_input(event: InputEvent) -> void:
	$StateMachine.process_input(event)


func _process(delta: float) -> void:
	$StateMachine.process_frame(delta)
