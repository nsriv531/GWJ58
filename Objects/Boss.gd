extends Area2D

enum{IDLE,ACTIVE,DEAD,HIT,ATTACK,TRANSFORM, FINALDEAD}
enum{MOVE_LEFT,MOVE_RIGHT}

signal boss_healthbar_create(health)
signal boss_healthbar_set(health)

var player
var state
var health
var move_to_pos
var move_dir
var hittable
var phase

var dead_pos
var temp_pos

var before_hit_state

var deadboss = preload("res://Objects/DeadBoss.tscn")

var left_pos = Vector2(-10, 299)
var right_pos = Vector2(1044, 299)

@onready var boss_hit = $BossGetsHit
# Called when the node enters the scene tree for the first time.

func setup():
	self.modulate.a = 1.0
	hittable = true
	move_dir = MOVE_RIGHT
	$WaterCollision.disabled = true
	$WaterCollision2.disabled = true
	health = 2000
	boss_healthbar_create.emit(health)
	
func _ready():
	
	$AnimatedSprite2D.play("idle")
	player = self.get_parent().get_node("Player")
	
	$WaterCollision.disabled = true
	$CollisionShape2D2.disabled = true
	
	$Line2D.visible = false
	
	state = IDLE
	phase = 1
	setup()

func _get_distance(n1, n2):
	var relx = n1.position.x - n2.position.x
	var rely = n1.position.x - n2.position.x
	var dist = sqrt(relx*relx +rely*rely)
	return dist

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if phase == 2 && state != FINALDEAD:
		$Line2D.clear_points()
		$Line2D.global_position = Vector2(0,0)
			
		$Line2D.add_point(self.position + Vector2(100,-50))
		$Line2D.add_point(dead_pos - Vector2(100,-70))
			
	if state == IDLE:
		if _get_distance(self,player) < 600:
			state = ACTIVE
			setup_timer()
			
	elif state == ACTIVE:
		$AnimatedSprite2D.play("active" + str(phase))
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
			$AnimatedSprite2D.play("active" + str(phase))
			self.position = self.position.move_toward(move_to_pos, 300*delta)
		else:
			$AnimatedSprite2D.play("spray" + str(phase))
			if phase == 1:
				if $AnimatedSprite2D.frame == 6:
					$WaterCollision.disabled = false
				if $AnimatedSprite2D.frame == 11:
					$WaterCollision.disabled = true
					state = ACTIVE
					setup_timer()
			elif phase == 2:
				if $AnimatedSprite2D.frame == 5:
					$WaterCollision2.disabled = false
				if $AnimatedSprite2D.frame == 10:
					$WaterCollision2.disabled = true
					state = ACTIVE
					setup_timer()
				
	elif state == DEAD:
		hittable = false
		if temp_pos == null:
			temp_pos = self.position
		if phase == 1:
			$AnimatedSprite2D.play("dead")
			if position.y <= 720:
				shake_position()
				position.y += delta * 70
			else:
				var deaadboss = deadboss.instantiate()
				deaadboss.position = self.position
				get_tree().get_root().get_child(0).add_child(deaadboss)
				$Line2D.visible = true
				dead_pos = self.position 
				setup()
				$CollisionShape2D2.disabled = false
				$CollisionShape2D.disabled = true
				
				get_tree().get_root().get_child(1).get_node("BossMusic").stop()
				get_tree().get_root().get_child(1).get_node("BossMusic2").play()
				
				state = ACTIVE
				phase = 2
				setup_timer()
		elif phase == 2:
			self.visible = false
			state = FINALDEAD

func shake_position():
	if Engine.get_frames_drawn() % 4 == 0:
		var rng = RandomNumberGenerator.new()
		position.x = temp_pos.x + rng.randi_range(-10, 10)

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
	boss_healthbar_set.emit(health)
	if health <= 0:
		state = DEAD
		#$AnimatedSprite2D.play("death")
	else:
		$Effects.play("hit")
		self.hittable = false
		
		$WaterCollision.disabled = true
		$WaterCollision2.disabled = true
		
		$HitTimer.start(2)
		
		before_hit_state = state
		state = HIT
		$AnimatedSprite2D.play("hit" + str(phase))
		if not boss_hit.playing:
			boss_hit.play()
			
func attack():
	state = ATTACK
	if phase == 1:
		move_to_pos = player.position - Vector2(-100, 200)
	elif  phase == 2:
		move_to_pos = player.position - Vector2(0, 100)

func _on_attack_timer_timeout():
	if state != DEAD && state != TRANSFORM:
		$AttackTimer.stop()
		self.attack()


func _on_hit_timer_timeout():
	if state != DEAD && state != FINALDEAD:
		$HitTimer.stop()
		$Effects.stop(false)
		self.modulate.a = 1.0
		hittable = true
	pass # Replace with function body.
