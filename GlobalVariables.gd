extends Node

var current_level

# Called when the node enters the scene tree for the first time.
func _ready():
	current_level = 1
	pass # Replace with function body.
	
func get_current_level() -> int:
	return current_level
	
func increase_current_level():
	current_level += 1
