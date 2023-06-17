extends Area2D

enum{IDLE,ACTIVE,DEAD,HIT,ATTACK}

var player
var state
var health
var move_to_pos
@onready var boss_hit = $BossGetsHit
# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.play("idle")
	player = self.get_parent().get_node("Player")
	
	health = 5000
	state = IDLE

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
			setup_timer()
			
	elif state == ACTIVE:
		$AnimatedSprite2D.play("active")
		
	elif state == HIT:
		if !$AnimatedSprite2D.is_playing():
			state = ACTIVE
			
	elif state == ATTACK:
		$AnimatedSprite2D.play("active")
		self.position = self.position.move_toward(move_to_pos, 300*delta)
		if self.position == move_to_pos:
			state = ACTIVE
			setup_timer()

func setup_timer():
	var rng = RandomNumberGenerator.new()
	$Timer.start(rng.randi_range(2,6))

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
		if not boss_hit.playing:
			boss_hit.play()
			
func attack():
	state = ATTACK
	move_to_pos = player.position - Vector2(0, 200)

func _on_timer_timeout():
	$Timer.stop()
	self.attack()
