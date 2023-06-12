extends CharacterBody2D

enum{IDLE, DUMP, WALK, HIT}

var waterfill = 0
const SPEED = 300.0
const JUMP_VELOCITY = -700.0

var waterParticle = preload("res://Scene/WaterParticle.tscn")

var state

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func isDumping():
	if state == DUMP:
		return true
	else:
		return false

func hit():
	velocity.x = -500
	velocity.y = JUMP_VELOCITY
	if waterfill < 800:
		$AnimatedSprite2D.play("hit_left")
	else:
		$AnimatedSprite2D.play("hit_left_full")
	state = HIT

func _ready():
	state = IDLE
	$Camera2D/Label.text = "Water:"
	$AnimatedSprite2D.play("idle")
	
func _process(delta):
	
	if state == HIT:
		if velocity.y == 0:
			state = IDLE
	
	if state == DUMP:
		if $AnimatedSprite2D.frame == 3:
			waterfill = 0
			state = IDLE
			
		if $AnimatedSprite2D.frame == 1:
			var part = waterParticle.instantiate()
			part.setAmount((1 + waterfill/40))
			add_child(part)
			part.start()
			
	$Camera2D/Label.text = "Water: " + str(waterfill) 


func _physics_process(delta):
	
	movement(delta)
	raycast_fill_water(delta)
	collisions()
	
	
func collisions():
	# Iterate through all collisions that occurred this frame
	for index in range(get_slide_collision_count()):
		# We get one of the collisions with the player
		var collision = get_slide_collision(index)


		# If the collision is with ground
		if (collision.get_collider().is_class("TileMap")):
			continue
			
		print (collision.get_collider())

		if collision.get_collider().is_in_group("Shrine"):
			var shrine = collision.get_collider()
			if waterfill >= 800:
				shrine.dump()

		# If the collider is with an enemy
		if collision.get_collider().is_in_group("Enemy"):
			var enemy = collision.get_collider()
			# we check that we are hitting it from above.
	
func raycast_fill_water(delta):
	var space_state = get_world_2d().direct_space_state
	# use global coordinates, not local to node
	var query = PhysicsRayQueryParameters2D.create(global_position, global_position + Vector2(0,-200))
	query.exclude = [self]
	var result = space_state.intersect_ray(query)
	if result.size() == 0 && waterfill < 1000:
		waterfill += ceil(delta*2)
		
func movement(delta):
	var speed = SPEED - (waterfill/8)
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += (gravity  + waterfill/2) * delta

	# Handle Jump.

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	
	if state == IDLE:
		var direction = Input.get_axis("left", "right")
		if direction > 0:
			if is_on_floor():
				if waterfill < 800:
					$AnimatedSprite2D.play("right_walk")
				else:
					$AnimatedSprite2D.play("right_walk_slow")
			velocity.x = direction * speed
		elif direction < 0:
			if is_on_floor():
				if waterfill < 800:
					$AnimatedSprite2D.play("left_walk")
				else:
					$AnimatedSprite2D.play("left_walk_slow")
			velocity.x = direction * speed
		else:
			if is_on_floor():
				if waterfill < 800:
					$AnimatedSprite2D.play("idle")
				else:
					$AnimatedSprite2D.play("idle_slow")
			velocity.x = move_toward(velocity.x, 0, speed)
		
		if Input.is_action_just_pressed("dump") and is_on_floor():
			state = DUMP
			if waterfill < 800:
				$AnimatedSprite2D.play("partial_dump")
			else:
				$AnimatedSprite2D.play("dump")
			
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY
			if direction > 0:
				if waterfill < 800:
					$AnimatedSprite2D.play("right_jump")
				else:
					$AnimatedSprite2D.play("right_jump_slow")
			elif direction < 0:
				if waterfill < 800:
					$AnimatedSprite2D.play("left_jump")
				else:
					$AnimatedSprite2D.play("left_jump_slow")
			else:
				if waterfill < 800:
					$AnimatedSprite2D.play("idle_jump")
				else:
					$AnimatedSprite2D.play("idle_jump_slow")
	if state != DUMP:
		move_and_slide()
