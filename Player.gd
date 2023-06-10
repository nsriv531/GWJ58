extends RigidBody2D

var grounded;

# Called when the node enters the scene tree for the first time.
func _ready():
	grounded  = false;

	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if Input.is_action_pressed("left"):
		set_linear_velocity(Vector2(-300, linear_velocity.y));
	elif Input.is_action_pressed("right"):
		set_linear_velocity(Vector2(300, linear_velocity.y));
	else:
		set_linear_velocity(Vector2(0, linear_velocity.y));
		
	if Input.is_action_pressed("jump") && grounded:
		apply_central_impulse(Vector2(0,-700))
	pass


func _on_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if body.get_name() == "ground" || body.get_name() == "TileMap":
		grounded  = true;
		



func _on_body_shape_exited(body_rid, body, body_shape_index, local_shape_index):
	if body.get_name() == "ground" || body.get_name() == "TileMap":
		grounded  = false;
