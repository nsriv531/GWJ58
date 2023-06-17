extends Control

func _ready():
	hide()
	pass


func _on_tittlescreen_pressed():
	get_tree().change_scene_to_file("res://Scene/TitleScreen.tscn")
	get_tree().paused = false
	pass # Replace with function body.


func _on_resume_pressed():
	get_tree().reload_current_scene()
	pass # Replace with function body.
