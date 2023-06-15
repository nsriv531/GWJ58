extends Area2D

@export var JUMP_HEIGHT = -800
@onready var animation = $AnimatedSprite2D 
signal Spring_Jump_velcity(jumpheight)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass








func _on_body_entered(body: Node2D) -> void:
	print_debug(body.get_node("RigidBody2D"))
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
