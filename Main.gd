extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$GPUParticles2D.position.x = $Player.position.x
	#$GPUParticles2D.position.y = $Player.position.y
	
	pass
