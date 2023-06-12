extends Area2D

var health = 1000

func squash(damage):
	health -= damage
	if health <= 0:
		self.queue_free()

func _ready():
	$AnimatedSprite2D.play("default")
	pass
	



func _on_body_entered(body):
	if body.is_in_group("Player"):
		if body.velocity.y > 0:
				# If so, we squash it and bounce.
			self.squash(body.waterfill)
			body.velocity.y = body.JUMP_VELOCITY
