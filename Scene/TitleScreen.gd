extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://Scene/Levels/Level1.tscn")
	hide()
	pass # Replace with function body.


func _on_quite_pressed() -> void:
	get_tree().quit()
	pass # Replace with function body.
