extends Node2D

signal next_level

var cur:int
var total:int
var level

# Called when the node enters the scene tree for the first time.
func _ready():
	cur = 0
	level = 0
	$EndFlagArea/Flag.modulate = Color(1,1,1)
	total = get_tree().get_nodes_in_group("Shrine").size()
	cur = total
	update_label()
	pass # Replace with function body.


func set_level(level):
	self.level = level

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
	if body.is_in_group("Player") && cur >= total:
		next_level.emit()


func _on_end_flag_area_body_exited(body):
	pass # Replace with function body.
