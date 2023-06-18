extends Control



var heart_size = Vector2(26,26)



func _on_life_changed(health) -> void:
	

	$heart.set_size(heart_size * Vector2(1 * health,1))    
	pass # Replace with function body.
