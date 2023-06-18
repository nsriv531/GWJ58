extends Area2D

var health_amount




func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		if(body.hearts < 3):
			body.restore_hearts(0.5)
			queue_free()
	pass # Replace with function body.
