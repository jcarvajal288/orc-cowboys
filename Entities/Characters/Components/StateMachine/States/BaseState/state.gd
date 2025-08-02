class_name State extends Node

@export var animation_name: String
@export var animate_with_facing: bool

var director: Director

var subject: CharacterBody2D

func enter() -> void:
	subject.animation_player.play("RESET")
	subject.animation_player.seek(1)
	if animate_with_facing:
		subject.animation_player.play_with_facing(animation_name)
	else:
		subject.animation_player.play(animation_name)


func exit() -> void:
	pass


func process_input(_event: InputEvent) -> State:
	return null


func process_physics(_delta: float) -> State:
	return null


func process_frame(_delta: float) -> State:
	return null
