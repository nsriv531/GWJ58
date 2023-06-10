extends CharacterBody2D

var grounded;

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.play("idle");
	grounded  = false;

	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if Input.is_action_pressed("left"):
		velocity.x = -200;
	elif Input.is_action_pressed("right"):
		velocity.x = 300;
	else:
		velocity.x = 0;
		
	if Input.is_action_pressed("jump") && grounded:
		velocity.y = 300
	pass


func _on_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if body.get_name() == "ground" || body.get_name() == "TileMap":
		grounded  = true;
		



func _on_body_shape_exited(body_rid, body, body_shape_index, local_shape_index):
	if body.get_name() == "ground" || body.get_name() == "TileMap":
		grounded  = false;
