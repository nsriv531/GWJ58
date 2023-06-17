extends CharacterBody2D

signal life_changed(health)
var damage = 0.5 
var max_hearts: int = 3
var hearts: float = max_hearts


signal player_dead


enum{IDLE, DUMP, HIT, LEFT,RIGHT}
@export var SPRING_VELOCITY: float = -1000.0
var water_fill = 0
const SPEED = 300.0
const JUMP_VELOCITY = -700.0
@onready var fullnotification = $FullNotif
@onready var walk_left = $walk_left
@onready var dump = $DumpNoise
@onready var jumpnoise = $jump
@onready var fulljumpnoise = $fulljump
var is_notify = false
var waterParticle = preload("res://Scene/WaterParticle.tscn")

var state

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _ready():
	
	state = IDLE
	life_changed.emit(hearts)
	$Camera2D/Label.text = "Water:"
	$AnimatedSprite2D.play("idle")
	
func _process(delta):
	
	if state == HIT:
		if velocity.y == 0:
			state = IDLE
	
	elif state == DUMP:
		if $AnimatedSprite2D.frame == 3:
			water_fill = 0
			state = IDLE
			
		if $AnimatedSprite2D.frame == 1:
			var part = waterParticle.instantiate()
			part.setAmount((1 + water_fill/40))
			add_child(part)
			part.start()
			
	elif state == IDLE:
		if not is_on_floor():
			var direction = Input.get_axis("left", "right")
			if direction > 0:
				jump_animation(RIGHT)
			elif direction < 0:
				jump_animation(LEFT)
			elif direction == 0:
				jump_animation(IDLE)
			
	$Camera2D/Label.text = "Water: " + str(water_fill) 


func _physics_process(delta):
	movement(delta)
	raycast_fill_water(delta)
	
func raycast_fill_water(delta):
	var space_state = get_world_2d().direct_space_state
	# use global coordinates, not local to node
	var query = PhysicsRayQueryParameters2D.create(global_position, global_position + Vector2(0,-800))
	query.exclude = [self]
	var result = space_state.intersect_ray(query)
	if result.size() == 0 && water_fill < 1000:
		water_fill += ceil(delta) * 2
	if water_fill > 1000:
		water_fill = 1000
		
func movement(delta):
	var speed = SPEED - (water_fill/8)
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += (gravity  + water_fill/2) * delta

	# Handle Jump.

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	
	if state == IDLE:
		var direction = Input.get_axis("left", "right")
		if direction > 0:
			if is_on_floor():
				if is_full():
					$AnimatedSprite2D.play("right_walk_slow")
				else:
					$AnimatedSprite2D.play("right_walk")
			velocity.x = direction * speed
		elif direction < 0:
			if is_on_floor():
				if is_full():
					$AnimatedSprite2D.play("left_walk_slow")
				else:
					$AnimatedSprite2D.play("left_walk")
					if not walk_left.playing:
						walk_left.play()
			velocity.x = direction * speed
		else:
			if is_on_floor():
				if is_full():
					$AnimatedSprite2D.play("idle_slow")
				else:
					$AnimatedSprite2D.play("idle")
			velocity.x = move_toward(velocity.x, 0, speed)
		
		if Input.is_action_just_pressed("dump") and is_on_floor():
			state = DUMP
			if is_full():
				if not dump.playing:
					dump.play()
				$AnimatedSprite2D.play("dump")
			else:
				if not dump.playing:
					dump.play()
				$AnimatedSprite2D.play("partial_dump")
			
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY
			
	if state != DUMP:
		move_and_slide()

func jump_animation(direction):
	if direction == LEFT:
		if is_full():
			$AnimatedSprite2D.play("left_jump_slow")
		else:
			if not jumpnoise.playing:
				jumpnoise.play()
			$AnimatedSprite2D.play("left_jump")
	elif direction == RIGHT:
		if is_full():
			$AnimatedSprite2D.play("right_jump_slow")
		else:
			if not jumpnoise.playing:
				jumpnoise.play()
			$AnimatedSprite2D.play("right_jump")
	elif direction == IDLE:
		if is_full():
			$AnimatedSprite2D.play("idle_jump_slow")
		else:
			if not jumpnoise.playing:
				jumpnoise.play()
			$AnimatedSprite2D.play("idle_jump")
			
func _on_spring_spring_jump_velcity(jumpheight) -> void:
	velocity.y = jumpheight
	state = IDLE
	pass # Replace with function body.

func hit(knock_back):
	velocity.x = knock_back
	velocity.y = JUMP_VELOCITY
	hearts -= damage 
	life_changed.emit(hearts)
	if(hearts <= 0):
		print_debug(hearts)

		player_dead.emit()
	else:
		if is_full():
			$AnimatedSprite2D.play("hit_left_full")
		else:
			$AnimatedSprite2D.play("hit_left")
		state = HIT

func is_full():
	if water_fill < 800:
		is_notify = false
		return false
	else:
		if not is_notify and not fullnotification.playing:
			is_notify = true
			fullnotification.play()
		return true
		
func is_dumping():
	if state == DUMP:
		return true
	else:
		return false

func _on_wind_push_player_back(speed) -> void:
	
	if !is_full():
		velocity.x = speed
		velocity.y = -100
		$AnimatedSprite2D.play("hit_left")
	state = HIT
	pass # Replace with function body.
