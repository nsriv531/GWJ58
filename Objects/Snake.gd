extends Area2D
enum{ALIVE,DEAD,HIT}

var is_moving_right = true
var linear_velocity = 50
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
	$Timer.start()
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
		movement(delta)
		$AnimatedSprite2D.play("default")
func movement(delta):
	if is_moving_right == true:
		position.x += linear_velocity * delta
		$AnimatedSprite2D.flip_h = true
	elif  is_moving_right == false:
		position.x += -linear_velocity * delta
		$AnimatedSprite2D.flip_h = false

func _on_body_entered(body):
	if body.is_in_group("Player") && state == ALIVE:
		if body.velocity.y > 0:
				# If so, we squash it and bounce.
			self.squash(body.water_fill)
			body.velocity.y = body.JUMP_VELOCITY
		else:
			body.hit()


func _on_timer_timeout() -> void:
	if  is_moving_right == true:
		is_moving_right= false
	elif is_moving_right == false:
		is_moving_right = true
	pass # Replace with function body.
