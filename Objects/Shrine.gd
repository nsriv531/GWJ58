extends Area2D

var player_overlap
var player
@export var shrine_variation:int = 1 
# Called when the node enters the scene tree for the first time.
func _ready():
	player_overlap = false
	$AnimatedSprite2D.play("var" + str(shrine_variation) + "_onfire")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player_overlap && player.is_dumping() && player.is_full():
		$AnimatedSprite2D.play("var" + str(shrine_variation) + "_notonfire")
	pass


func _on_body_entered(body):
	if body.is_in_group("Player"):
		player = body
		player_overlap = true


func _on_body_exited(body):
	if body.is_in_group("Player"):
		player_overlap = false
