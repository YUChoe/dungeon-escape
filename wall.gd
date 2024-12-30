extends Node2D

var WALL_TYPE = ""
var enter_from = ""
var exits = [] 
@onready var Node_Player = $"../Player"
@onready var Node_Game = $".."

func _ready() -> void:
	pass # Replace with function body.

func set_wall_type(wall_type):
	WALL_TYPE = wall_type
	
func set_door_old_location(was_before):
	var loc = was_before[0]
	var door = was_before[1]
	LOG('invoked %s, %s' % [loc, door])
	#enter_from = direction
	LOG("was before loc[%s] door[%s]" % [loc, door])
	

func _on_door_entered(body: Node2D, idx: int) -> void:
	LOG('invoked door idx:%d' % idx)
	#Node_Player.on_door_entered("south")
	# TODO: by idx 
	Node_Game.change_scene_from_current_location("south")
	
func LOG(s):
	print("%10.3f [%-15s] %s" % [Time.get_unix_time_from_system(), 
			"%s.%s" % [name, get_stack()[1]["function"]], s])
