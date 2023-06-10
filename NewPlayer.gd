extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -700.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _ready():
	$AnimatedSprite2D.play("idle")

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("left", "right")
	if direction > 0:
		if is_on_floor():
			$AnimatedSprite2D.play("right_walk")
		velocity.x = direction * SPEED
	elif direction < 0:
		if is_on_floor():
			$AnimatedSprite2D.play("left_walk")
		velocity.x = direction * SPEED
	else:
		if is_on_floor():
			$AnimatedSprite2D.play("idle")
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		if direction > 0:
			$AnimatedSprite2D.play("right_jump")
		else:
			$AnimatedSprite2D.play("left_jump")
	move_and_slide()
