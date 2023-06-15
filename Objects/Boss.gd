extends Area2D
enum{IDLE,ACTIVE}
var player
var state
# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.play("idle")
	player = self.get_parent().get_node("Player")
	
	state = IDLE
	
	pass # Replace with function body.

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
	elif state = ACTIVE:
		$AnimatedSprite2D.play("active")
	pass
