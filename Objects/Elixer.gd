extends Area2D

@export var health_amount = 0.5
@onready var powerup_noise = $PowerUp 
var can_heal_player:bool = true


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		if(body.hearts < 3) and can_heal_player:
			can_heal_player = false
			body.restore_hearts(0.5)
			if not powerup_noise.playing:
				powerup_noise.play()
			$Timer.start()
			hide()
			
	pass # Replace with function body.

func _on_timer_timeout() -> void:
	can_heal_player = true
	show()
	pass # Replace with function body.
