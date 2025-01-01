extends Node2D

@onready var Wall1 = $Wall_has_1exit
@onready var Wall2 = $Wall_has_2exit
@onready var Node_Player = $Player
var is_changing_scene = false
var current_location = "0,0"
var was_before = []
# n -> s -> e -> w
var map = {
	"0,0": {
		"type": "starting",
		"north": ["0,1", "south"]
	},
	"0,1": {
		"type": "ns",
		"north": ["0,2", "south"],
		"south": ["0,0", "north"]
	},
	"0,2": {
		"type": "se",
		"east": ["1,2", "west"],
		"south": ["0,1", "north"]
	},
	"1,2": {
		"type": "nsw",
		"north": ["1,3", ""],
		"south": ["1,1", ""],
		"west": ["0,2", "east"]
	}
}
var starting_point

func _ready() -> void:
	hide_all()
	LOG("starting %s" % map[current_location])
	starting_point = Node_Player.position
	was_before = ["0,0", "south"]  # 0,0 
	LOG("set Player pos %s" % starting_point)
	showup(current_location)

func change_scene_from_current_location(exit_door: String) -> void:
	LOG("curr map[%s] exit[%s]" % [current_location, exit_door])
	is_changing_scene = true
	if exit_door not in map[current_location]:
		LOG("ERROR no exit %s" % exit_door)
		return
	# changing data
	var addr = map[current_location][exit_door]
	was_before = [current_location, addr[1]]
	current_location = addr[0]
	LOG("was before %s, %s" % [addr[0], addr[1]])
	LOG("to map[%s]" % current_location)
	hide_all()
	showup(current_location)
	is_changing_scene = false

func hide_all():
	LOG('invoked')
	for target in [ Wall1, Wall2 ]:
		
		target.hide()
		target.process_mode = Node.PROCESS_MODE_DISABLED
	
func showup(addr):
	LOG('invoked room addr %s' % addr)
	var target 
	
	if addr not in map: 
		# some error 
		return 
	LOG("map[%s][type] is %s" % [addr, map[addr]["type"]])
	$UI/PositionLabel.text = addr
	if map[addr]["type"] in [ "ns", "ew", "nw", "ne", "sw", "se", "starting" ]:
		LOG("type %s" % map[addr]["type"])
		target = Wall1
	elif map[addr]["type"] in [ "n", "s", "e", "w" ]:
		# TODO: no way to get back  
		LOG("type %s" % map[addr]["type"])
		pass
	elif map[addr]["type"] in [ "nse", "nsw", "new", "sew" ]:
		LOG("type %s" % map[addr]["type"])
		target = Wall2
	elif map[addr]["type"] == "nsew":  # cross
		LOG("type %s" % map[addr]["type"])
		# target = Wall3
		pass
	if target == null:
		# some error
		return
	target.show()
	target.process_mode = 0  # enable collusion events
	target.init_room(map[current_location], was_before[1])
	#target.set_door_old_location(was_before)
	#target.set_room(map[current_location])
	Node_Player.move_to(starting_point)

func LOG(s):
	print("%10.3f [%-15s:%d] %s" % [Time.get_unix_time_from_system(), 
			"%s.%s" % [name, get_stack()[1]["function"]], get_stack()[1]["line"], s])
