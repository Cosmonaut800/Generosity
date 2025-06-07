extends Node3D

@onready var blackout := $UI/Black

var world_templates : Array[Resource] =\
[	preload("res://src/Scenes/hub_map.tscn"),
	preload("res://src/Scenes/course_1Artpass.tscn"),
	preload("res://src/Scenes/course_2Artpass.tscn"),
	preload("res://src/Scenes/course_3.tscn")]
var world : Node3D
var subworld : Node3D
var current_index := 0
var current_config := 3

func _ready():
	load_world(world_templates[current_index])

func _on_world_reset():
	var tween = create_tween()
	tween.tween_property(blackout, "color", Color(0.0, 0.0, 0.0, 1.0), 0.5)
	tween.tween_callback(world.queue_free)
	tween.tween_interval(0.25)
	tween.tween_callback(load_world.bind(world_templates[current_index]))
	tween.tween_interval(0.25)
	tween.tween_property(blackout, "color", Color(0.0, 0.0, 0.0, 0.0), 0.5)

func _on_world_changed(index: int, config: int):
	current_index = index
	current_config = config
	_on_world_reset()

func load_world(world_template: Resource):
	world = world_templates[current_index].instantiate()
	world.set_process_mode(Node.PROCESS_MODE_PAUSABLE)
	add_child(world)
	move_child(world, 0)
	world.reset.connect(_on_world_reset)
	world.world_changed.connect(_on_world_changed)
	
	if current_config > 0:
		subworld = world.subworlds[current_config-1].instantiate()
		subworld.set_process_mode(Node.PROCESS_MODE_PAUSABLE)
		world.add_child(subworld)
	
	#Do something similar for the village to account for kodama
	#if current_index == 1: //or whatever the village index is
	#	yada yada
