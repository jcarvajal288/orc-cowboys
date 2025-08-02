class_name Critter extends CharacterBody2D

@onready var animation_player = $AnimationPlayer

var speed = 20
var score = 10

var is_outside_spawn_area = false

func _ready() -> void:
	$Sprite2D.z_index = Global.RenderOrder.PLAYER
	set_collision_layer_value(Global.CollisionLayer.SPAWN_AREA, true)
	# set_collision_mask_value(Global.CollisionLayer.SPAWN_AREA, true)
	$StateMachine.init(self)

func _physics_process(delta: float) -> void:
	$StateMachine.process_physics(delta)


func _unhandled_input(event: InputEvent) -> void:
	$StateMachine.process_input(event)


func _process(delta: float) -> void:
	$StateMachine.process_frame(delta)


func has_left_spawn_area(_body: Node2D) -> void:
	is_outside_spawn_area = true


func has_entered_spawn_area(_body: Node2D) -> void:
	is_outside_spawn_area = false