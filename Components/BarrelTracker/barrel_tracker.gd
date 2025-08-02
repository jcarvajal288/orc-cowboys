class_name BarrelTracker extends Node2D

@export var max_barrels: int

var num_placed_barrels: int


func _ready() -> void:
	reset()


func reset() -> void:
	num_placed_barrels = max_barrels
	update_label()


func subtract_barrel() -> void:
	num_placed_barrels -= 1
	update_label()


func out_of_barrels() -> bool:
	return num_placed_barrels <= 0


func update_label():
	$LabelCanvas/Label.text = "%d" % num_placed_barrels