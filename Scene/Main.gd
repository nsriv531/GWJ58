extends Node2D
signal  pause_game_signal
@export var level_num:int = 1
@onready var player = $Player
@onready var pause_menue = $Player/PauseScreen
# Called when the node enters the scene tree for the first time.
func _ready():

	var endflag = $EndFlag
   
	if(endflag != null):
		endflag.next_level.connect(next_level)
	
	var shrines = get_tree().get_nodes_in_group("Shrine")
	for shrine in shrines:
		endflag.connect_shrine(shrine)
	pass # Replace with function body.

func get_player():
	return player

func next_level():
	var dir = DirAccess.open("res://Scene/Levels/")
	var total_levels = dir.get_files().size()
	if level_num < total_levels:
		get_tree().change_scene_to_file("res://Scene/Levels/Level" + str(level_num + 1) + ".tscn")
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$GPUParticles2D.position.x = $Player.position.x
	#$GPUParticles2D.position.y = $Player.position.y
	if Input.is_action_just_pressed("pause"):
		pause_Game()
	
	pass
	

func pause_Game():
	pause_menue.show()
	get_tree().paused = true
	pass

