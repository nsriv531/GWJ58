extends Area2D

@export var JUMP_HEIGHT = -800
@onready var animation = $AnimatedSprite2D 
signal Spring_Jump_velcity(jumpheight)









func _on_body_entered(body: Node2D) -> void:
	Spring_Jump_velcity.emit(JUMP_HEIGHT)
	$SpringDefualtimer.start()
	animation.play("activate")
	
	pass # Replace with function body.


func _on_body_exited(body: Node2D) -> void:

	pass # Replace with function body.





func _on_spring_defualtimer_timeout() -> void:
	$SpringDefualtimer.stop()
	animation.play("default")
	pass # Replace with function body.
