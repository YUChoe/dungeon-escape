extends Node2D

@onready var Wall1 = $Wall_has_1exit
@onready var Wall2 = $Wall_has_2exit
var is_changing_scene = false
var current_location = "0,0"
var was_before = []
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
	starting_point = $Player.position
	was_before = ["0,0", "south"]  # 0,0 
	LOG("set Player pos %s" % starting_point)
	showup(current_location)

func change_scene_from_current_location(door: String) -> void:
	LOG("curr map[%s] exit[%s]" % [current_location, door])
	is_changing_scene = true
	if door not in map[current_location]:
		LOG("ERROR no exit %s" % door)
		return
	var addr = map[current_location][door]
	# changing data
	was_before = [current_location, addr[1]]
	current_location = addr[0]
	LOG("was before %s, %s" % [addr[0], addr[1]])
	LOG("to map[%s]" % current_location)
	showup(current_location)
	is_changing_scene = false
	

func hide_all():
	LOG('invoked')
	for target in [ Wall1, Wall2 ]:  # TODO: add more 
		target.hide()
		target.process_mode = Node.PROCESS_MODE_DISABLED
	
func showup(location):
	LOG('invoked')
	var target 
	
	if location not in map: 
		# some error 
		return 
	LOG("map[%s][type] is %s" % [location, map[location]["type"]])
	$UI/PositionLabel.text = location
	if map[location]["type"] in [ "ns", "ew", "starting", "nw", "ne", "sw", "se" ]:
		target = Wall1
	elif map[location]["type"] in [ "n", "s", "e", "w" ]:
		# TODO: no way to get back  
		pass
	elif map[location]["type"] in [ "nse", "nsw", "new", "sew" ]:
		target = Wall2
	elif map[location]["type"] == "nsew":  # cross
		pass
	if target == null:
		# some error
		return
	target.show()
	target.process_mode = 0  # enable collusion events
	target.set_door_old_location(was_before)
	$Player.move_to(starting_point)
		

func LOG(s):
	print("%10.3f [%-15s] %s" % [Time.get_unix_time_from_system(), 
			"%s.%s" % [name, get_stack()[1]["function"]], s])
