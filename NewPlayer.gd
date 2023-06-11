extends CharacterBody2D


var waterfill = 0
const SPEED = 300.0
const JUMP_VELOCITY = -700.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _ready():
	get_node("../Label").text = "Water:"
	$AnimatedSprite2D.play("idle")

func _process(delta):
	get_node("../Label").text = "Water: " + str(waterfill) 

func _physics_process(delta):
	
	var speed = SPEED - (waterfill/8)
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += (gravity  + waterfill/2) * delta

	# Handle Jump.

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("left", "right")
	if direction > 0:
		if is_on_floor():
			$AnimatedSprite2D.play("right_walk")
		velocity.x = direction * speed
	elif direction < 0:
		if is_on_floor():
			$AnimatedSprite2D.play("left_walk")
		velocity.x = direction * speed
	else:
		if is_on_floor():
			$AnimatedSprite2D.play("idle")
		velocity.x = move_toward(velocity.x, 0, speed)
		
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		if direction > 0:
			$AnimatedSprite2D.play("right_jump")
		else:
			$AnimatedSprite2D.play("left_jump")
	move_and_slide()
	
	var space_state = get_world_2d().direct_space_state
	# use global coordinates, not local to node
	var query = PhysicsRayQueryParameters2D.create(global_position, global_position + Vector2(0,-200))
	query.exclude = [self]
	var result = space_state.intersect_ray(query)
	if result.size() == 0 && waterfill < 1000:
		waterfill += ceil(delta)
		
