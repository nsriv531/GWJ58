extends Area2D

var player_overlap
var player

# Called when the node enters the scene tree for the first time.
func _ready():
	player_overlap = false
	$AnimatedSprite2D.play("onfire")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player_overlap && player.isDumping() && player.waterfill >= 800:
		$AnimatedSprite2D.play("notonfire")
	pass


func _on_body_entered(body):
	if body.is_in_group("Player"):
		player = body
		player_overlap = true


func _on_body_exited(body):
	if body.is_in_group("Player"):
		player_overlap = false
