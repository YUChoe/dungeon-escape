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
	#if WALL_TYPE in ["ns", "se", "starting" ]:
		#for nd in [ "north", "south", "east", "west" ]:
			#if nd == enter_door: continue
			#if nd not in Info: continue
			#Doors_byIdx.append(nd)
	for nd in [ "north", "south", "east", "west" ]:
		if nd == enter_door: continue
		if nd not in Info: continue
		Doors_byIdx.append(nd)
	LOG("Doors_byIdx size[%d]" % (Doors_byIdx.size()))
	for nd in Doors_byIdx:
		LOG("Door: %s" % nd)
	
func _on_door_entered(body: Node2D, idx: int) -> void:
	LOG('invoked door idx:%d' % idx)
	# NOTE: only handle events -> stage_manager
	LOG('Doors_byIdx[%d]: %s' % [idx, Doors_byIdx[idx]])
	Node_Game.change_scene_from_current_location(Doors_byIdx[idx])

func LOG(s):
	print("%10.3f [%-15s:%d] %s" % [Time.get_unix_time_from_system(), 
			"%s.%s" % [name, get_stack()[1]["function"]], get_stack()[1]["line"], s])



func _on_door_1_body_entered(body: Node2D, extra_arg_0: int) -> void:
	pass # Replace with function body.
