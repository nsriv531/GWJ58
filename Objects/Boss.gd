extends Area2D

enum{IDLE,ACTIVE,DEAD,HIT,ATTACK}
enum{MOVE_LEFT,MOVE_RIGHT}

var player
var state
var health
var move_to_pos
var move_dir
var hittable

var before_hit_state

var left_pos = Vector2(-10, 299)
var right_pos = Vector2(1044, 299)

@onready var boss_hit = $BossGetsHit
# Called when the node enters the scene tree for the first time.
func _ready():
	self.modulate.a = 1.0
	$AnimatedSprite2D.play("idle")
	player = self.get_parent().get_node("Player")
	
	$WaterCollision.disabled = true
	
	hittable = true
	move_dir = MOVE_RIGHT
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
		if move_dir == MOVE_RIGHT:
			self.position = self.position.move_toward(right_pos, 300*delta)
			if self.position.x >= right_pos.x:
				move_dir = MOVE_LEFT
		elif move_dir == MOVE_LEFT:
			self.position = self.position.move_toward(left_pos, 300*delta)
			if self.position.x <= left_pos.x:
				move_dir = MOVE_RIGHT
		
	elif state == HIT:
		if !$AnimatedSprite2D.is_playing():
			state = before_hit_state
			
	elif state == ATTACK:
		if self.position != move_to_pos:
			$AnimatedSprite2D.play("active")
			self.position = self.position.move_toward(move_to_pos, 300*delta)
		else:
			$AnimatedSprite2D.play("spray")
			if $AnimatedSprite2D.frame == 6:
				$WaterCollision.disabled = false
			if $AnimatedSprite2D.frame == 11:
				$WaterCollision.disabled = true
				state = ACTIVE
				setup_timer()

func setup_timer():
	var rng = RandomNumberGenerator.new()
	$AttackTimer.start(rng.randi_range(2,6))

func _on_body_entered(body):
	if body.is_in_group("Player") && state != DEAD && hittable:
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
		
		$Effects.play("hit")
		self.hittable = false
		$WaterCollision.disabled = false
		$HitTimer.start(2)
		
		before_hit_state = state
		state = HIT
		$AnimatedSprite2D.play("hit")
		if not boss_hit.playing:
			boss_hit.play()
			
func attack():
	state = ATTACK
	move_to_pos = player.position - Vector2(-100, 200)

func _on_attack_timer_timeout():
	$AttackTimer.stop()
	self.attack()


func _on_hit_timer_timeout():
	$HitTimer.stop()
	$Effects.stop(false)
	self.modulate.a = 1.0
	hittable = true
	pass # Replace with function body.
