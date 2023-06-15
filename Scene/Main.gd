extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	var endflag = $EndFlag
	var shrines = get_tree().get_nodes_in_group("Shrine")
	for shrine in shrines:
		endflag.connect_shrine(shrine)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$GPUParticles2D.position.x = $Player.position.x
	#$GPUParticles2D.position.y = $Player.position.y
	
	pass
