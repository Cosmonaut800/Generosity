extends Node3D

@onready var blackout := $UI/Black
@onready var music_village : Array[AudioStreamPlayer3D] =\
[	$Music/Village/MusicK0,
	$Music/Village/MusicK1,
	$Music/Village/MusicK2,
	$Music/Village/MusicK3]
@onready var music_intro : Array[AudioStreamPlayer3D] =\
[	$Music/Course1/MusicIntro,
	$Music/Course2/MusicIntro,
	$Music/Course3/MusicIntro]
@onready var music_loop : Array[AudioStreamPlayer3D] =\
[	$Music/Course1/MusicLoop,
	$Music/Course2/MusicLoop,
	$Music/Course3/MusicLoop]

var world_templates : Array[Resource] =\
[	preload("res://src/Scenes/hub_map.tscn"), #0
	preload("res://src/Scenes/course_1Artpass.tscn"), #1
	preload("res://src/Scenes/course_2Artpass.tscn"), #2
	preload("res://src/Scenes/course_3Artpass.tscn"), #3
	preload("res://src/Scenes/VillageScenes/Villagebase.tscn"), #4
	preload("res://src/Scenes/start_menu.tscn")] #5
var kodama_templates : Array[Resource] =\
[	preload("res://src/Scenes/VillageScenes/VillageK0.tscn"),
	preload("res://src/Scenes/VillageScenes/VillageK1.tscn"),
	preload("res://src/Scenes/VillageScenes/VillageK3.tscn"),
	preload("res://src/Scenes/VillageScenes/VillageK6.tscn")]
var world : Node3D
var subworld : Node3D
var kodamaworld : Node3D
var prev_index := 0
var current_index := 5
var current_config := 0

var buses = {1:"MusicCourse1", 2:"MusicCourse2", 3:"MusicCourse3", 4:"MusicVillage"}
var music_index

func _ready():
	load_world(world_templates[current_index])

func _input(event):
	if current_index != 5:
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED and event.is_action_pressed("ui_cancel"):
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE and event.is_action_pressed("fire"):
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _on_world_reset():
	var tween = create_tween()
	tween.tween_callback(end_music)
	tween.tween_property(blackout, "color", Color(0.0, 0.0, 0.0, 1.0), 0.5)
	tween.tween_callback(world.queue_free)
	tween.tween_interval(0.25)
	tween.tween_callback(load_world.bind(world_templates[current_index]))
	tween.tween_interval(0.25)
	tween.tween_property(blackout, "color", Color(0.0, 0.0, 0.0, 0.0), 0.5)
	tween.tween_callback(start_music)

func _on_world_changed(index: int, config: int):
	prev_index = current_index
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
		subworld.world_changed.connect(_on_world_changed)
	
	if current_index == 4:
		Utility.evaluate_kodama_level()
		kodamaworld = kodama_templates[Utility.kodama_level].instantiate()
		kodamaworld.set_process_mode(Node.PROCESS_MODE_PAUSABLE)
		world.add_child(kodamaworld)
		if !music_village[Utility.kodama_level].playing:
			music_village[Utility.kodama_level].play()
		

func change_village_volume(value):
	music_village[Utility.kodama_level].volume_db = linear_to_db(value)

func change_course_volume(value):
	music_intro[music_index].volume_db = linear_to_db(value)
	music_loop[music_index].volume_db = linear_to_db(value)

func end_music():
	if (prev_index == 0 or prev_index == 5) and current_index != 4:
		Utility.evaluate_kodama_level()
		var tween = create_tween()
		tween.tween_method(change_village_volume, 1.0, 0.0, 3.0)
		tween.tween_callback(music_village[Utility.kodama_level].stop)
		tween.tween_property(music_village[Utility.kodama_level], "volume_db", 0.0, 0.0)
		#if current_index >= 1 and current_index <=3:
			#music_intro[current_index-1].play()
		
	if prev_index >= 1 and prev_index <= 3:
		music_index = prev_index - 1
		var tween = create_tween()
		tween.tween_method(change_course_volume, 1.0, 0.0, 3.0)
		tween.tween_callback(music_intro[music_index].stop)
		tween.tween_callback(music_loop[music_index].stop)
		tween.tween_property(music_intro[music_index], "volume_db", 0.0, 0.0)
		tween.tween_property(music_loop[music_index], "volume_db", 0.0, 0.0)

func start_music():
	if current_index >= 1 and current_index <=3:
		music_intro[current_index-1].play()
