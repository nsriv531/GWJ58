extends Area2D

enum{IDLE,ACTIVE,DEAD,HIT}

var player
var state
var health
# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.play("idle")
	player = self.get_parent().get_node("Player")
	
	health = 5000
	state = IDLE
	
	pass # Replace with function body.

func _get_distance(n1, n2):
	var relx = n1.position.x - n2.position.x
	var rely = n1.position.x - n2.position.x
	var dist = sqrt(relx*relx +rely*rely)
	return dist

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if state == IDLE:
		if _get_distance(self,player) < 600:
			state = ACTIVE
	elif state == ACTIVE:
		$AnimatedSprite2D.play("active")
	elif state == HIT:
		if !$AnimatedSprite2D.is_playing():
			state = ACTIVE
	pass

func _on_body_entered(body):
	if body.is_in_group("Player") && state != DEAD:
		if body.velocity.y > 0 && body.position.y < (self.position.y - 100):
				# If so, we squash it and bounce.
			self.squash(body.water_fill)
			body.velocity.y = body.JUMP_VELOCITY
		else:
			if(body.position.x < self.position.x):
				body.hit(-500) 
			else: 
				body.hit(500)

func squash(damage):
	health -= damage
	if health <= 0:
		state = DEAD
		#$AnimatedSprite2D.play("death")
	else:
		state = HIT
		$AnimatedSprite2D.play("hit")
