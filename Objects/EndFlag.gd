extends Node2D

var num_of_shrines
var cur:int
var total:int

# Called when the node enters the scene tree for the first time.
func _ready():
	cur = 0
	$EndFlagArea/Flag.modulate = Color(1,1,1)
	total = get_tree().get_nodes_in_group("Shrine").size()
	update_label()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func connect_shrine(shrine):
	shrine.on_shrine_dumped.connect(on_shrine_dumped)

func on_shrine_dumped():
		cur += 1
		update_label()

func update_label():
	var label = $Label
	label.text = (str(cur) + " / " + str(total))
	
func _on_end_flag_area_body_entered(body):
	pass # Replace with function body.


func _on_end_flag_area_body_exited(body):
	pass # Replace with function body.
