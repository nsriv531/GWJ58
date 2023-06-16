extends Control



var heart_size = Vector2(73,112)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:

	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_life_changed(health) -> void:
	
	print_debug( health)
	$heart.set_size(heart_size * Vector2(1 * health,1))    
	pass # Replace with function body.
