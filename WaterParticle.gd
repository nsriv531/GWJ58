extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$GPUParticles2D.emitting = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $GPUParticles2D.emitting == false:
		self.queue_free()
	pass
	
func setAmount(am):
	$GPUParticles2D.amount = am
	
func start():
	$GPUParticles2D.emitting = true
