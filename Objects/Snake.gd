extends Area2D
enum{ALIVE,DEAD,HIT}

var health = 1000
var state

func squash(damage):
	health -= damage
	if health <= 0:
		state = DEAD
		$AnimatedSprite2D.play("death")
	else:
		state = HIT
		$AnimatedSprite2D.play("hit")

func _ready():
	state = ALIVE
	$AnimatedSprite2D.play("default")
	pass
	

func _process(delta):
	if state == DEAD:
		if $AnimatedSprite2D.frame == 1:
			self.queue_free()
	if state == HIT:
		if $AnimatedSprite2D.frame == 1:
			state = ALIVE
	if state == ALIVE:
		$AnimatedSprite2D.play("default")


func _on_body_entered(body):
	if body.is_in_group("Player") && state == ALIVE:
		if body.velocity.y > 0:
				# If so, we squash it and bounce.
			self.squash(body.waterfill)
			body.velocity.y = body.JUMP_VELOCITY
		else:
			body.hit()
