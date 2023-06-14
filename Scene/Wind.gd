extends Area2D

@export var PUSHBACK_VELOCITY = 20.0
# 
signal push_player_back(speed)

func _ready() -> void:
	$AnimatedSprite2D.play("default")
	pass

func _on_body_entered(body: Node2D) -> void:
	push_player_back.emit(PUSHBACK_VELOCITY)
	$Timer.start()
	pass # Replace with function body.


func _on_timer_timeout() -> void:
	pass # Replace with function body.


func _on_body_exited(body: Node2D) -> void:
	$Timer.stop()
	pass # Replace with function body.
