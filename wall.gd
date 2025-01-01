extends Node2D

var WALL_TYPE = ""
var enter_from = ""
var Info = {}
var exits = [] 
@onready var Node_Player = $"../Player"
@onready var Node_Game = $".."

var Doors_byIdx = []

func _ready() -> void:
	pass # Replace with function body.

func init_room(room_info, enter_door):
	LOG("info: %s, enter_door: %s" % [room_info, enter_door])
	Info = room_info
	WALL_TYPE = Info["type"]
	Doors_byIdx = []
	for nd in [ "north", "south", "east", "west" ]:
		if nd == enter_door: continue
		if nd not in Info: continue
		Doors_byIdx.append(nd)

func _on_door_entered(body: Node2D, idx: int) -> void:
	LOG('invoked door idx:%d' % idx)
	# NOTE: only handle events -> stage_manager
	LOG('Doors_byIdx[%d]: %s' % [idx, Doors_byIdx[idx]])
	Node_Game.change_scene_from_current_location(Doors_byIdx[idx])
	
func LOG(s):
	var funcname = get_stack()[1]["function"] if len(get_stack()) > 1 and "function" in get_stack()[1] else "''"
	var linenum = get_stack()[1]["line"] if len(get_stack()) > 1 and "line" in get_stack()[1] else "-1"
	print("%10.3f [%-15s:%d] %s" % [Time.get_unix_time_from_system(), 
			"%s.%s" % [name, funcname], linenum, s])
