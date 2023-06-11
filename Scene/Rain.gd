extends Node2D

@onready var _animation = $AnimatedSprite2D
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_animation.play("rain")
	pass


func _on_ready():
	
	pass # Replace with function body.
