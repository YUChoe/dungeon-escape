extends CharacterBody2D

@export var speed = 400
@onready var stage_manager = $".."

func _ready() -> void:
	pass # Replace with function body.

func get_input():
	var input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if not stage_manager.is_changing_scene:
		velocity = input_direction * speed
	else:
		velocity = Vector2.ZERO
	if Input.is_action_just_pressed("ui_select"): 
		print("space")   
		position = stage_manager.starting_point

func move_to(new_position):
	LOG(new_position)
	position = new_position

func _physics_process(delta):
	get_input()
	move_and_slide()

func LOG(s):
	print("%10.3f [%-15s:%d] %s" % [Time.get_unix_time_from_system(), 
			"%s.%s" % [name, get_stack()[1]["function"]], get_stack()[1]["line"], s])
