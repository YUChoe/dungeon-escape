extends Node2D

@onready var Wall0 = $Wall_has_0exit
@onready var Wall1 = $Wall_has_1exit
@onready var Wall2 = $Wall_has_2exit
@onready var Wall3 = $Wall_has_3exit
@onready var Node_Player = $Player
var is_changing_scene = false
var current_location = "0,0"
var Was_before = []
# n -> s -> e -> w
var MAP = {}
var _MAP = {
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
		"north": ["1,3", "south"],
		"south": ["1,1", "north"],
		"west": ["0,2", "east"]
	},
	"1,1": {
		"type": "ne",
		"north": ["1,2", "south"],
		"east": ["2,1", "west"]
	},
	"2,1": {
		"type": "sew",
		"south": ["2,0", "north"],
		"east": ["3,1", "west"],
		"west": ["1,1", "east"]
	},
	"3,1": {
		"type": "nw",
		"north": ["3,2", "south"],
		"west": ["2,1", "east"]
	}
}
var starting_point

func _ready() -> void:
	# ~/.local/share/godot/app_userdata/dungeon escape
	var file = FileAccess.open("user://file_data.json", FileAccess.READ)
	MAP = JSON.parse_string(file.get_as_text())
	hide_all()
	LOG("starting %s" % MAP[current_location])
	starting_point = Node_Player.position
	Was_before = ["0,0", "south"]  # 0,0 
	LOG("set Player pos %s" % starting_point)
	showup(current_location)

func change_scene_from_current_location(exit_door: String) -> void:
	LOG("curr map[%s] exit[%s]" % [current_location, exit_door])
	is_changing_scene = true
	if exit_door not in MAP[current_location]:
		LOG("ERROR no exit %s" % exit_door)
		return
	# changing data
	var addr = MAP[current_location][exit_door]
	Was_before = [current_location, addr[1]]
	current_location = addr[0]
	LOG("was before %s, %s" % [addr[0], addr[1]])
	LOG("to map[%s]" % current_location)
	hide_all()
	showup(current_location)
	is_changing_scene = false

func hide_all():
	LOG('invoked')
	for target in [ Wall0, Wall1, Wall2, Wall3 ]:
		target.hide()
		target.process_mode = Node.PROCESS_MODE_DISABLED
	
func showup(addr):
	LOG('invoked room addr %s' % addr)
	var target 
	if addr not in MAP: 
		LOG("Error no [%s] in MAP" % addr) 
		return 
	LOG("map[%s][type] is %s" % [addr, MAP[addr]["type"]])
	$UI/PositionLabel.text = addr
	if MAP[addr]["type"] in [ "ns", "ew", "nw", "ne", "sw", "se", "starting" ]:
		LOG("type %s" % MAP[addr]["type"])
		target = Wall1
	elif MAP[addr]["type"] in [ "n", "s", "e", "w" ]:
		LOG("type %s" % MAP[addr]["type"])
		target = Wall0
	elif MAP[addr]["type"] in [ "nse", "nsw", "new", "sew" ]:
		LOG("type %s" % MAP[addr]["type"])
		target = Wall2
	elif MAP[addr]["type"] == "nsew":
		LOG("type %s" % MAP[addr]["type"])
		target = Wall3
	if target == null:
		LOG("Error target is null")
		return
	target.show()
	target.process_mode = 0  # enable collusion events
	target.init_room(MAP[current_location], Was_before[1])
	Node_Player.move_to(starting_point)
	
func _on_turning_back_door_body_entered(body: Node2D) -> void:
	var t = MAP[current_location]["type"]
	if t in [ "starting", "ending" ]: 
		LOG("no turning back")
		return
	change_scene_from_current_location(Was_before[1])
	Node_Player.position.y = -50

func LOG(s):
	var funcname = get_stack()[1]["function"] if len(get_stack()) > 1 and "function" in get_stack()[1] else "''"
	var linenum = get_stack()[1]["line"] if len(get_stack()) > 1 and "line" in get_stack()[1] else "-1"
	print("%10.3f [%-15s:%d] %s" % [Time.get_unix_time_from_system(), 
			"%s.%s" % [name, funcname], linenum, s])
