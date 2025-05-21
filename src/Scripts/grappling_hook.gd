extends Node3D

@export var travel_time := 0.2

@onready var ray := $RayCast3D
@onready var graphics := $Graphics

var tween : Tween
var destination := Vector3.ZERO
var hook_origin : Node3D

signal assign_grappling_hook_origin(hook_origin: Vector3)

func _ready():
	pass

func _physics_process(delta):
	pass

func fire():
	graphics.global_position = hook_origin.global_position
	
	if ray.is_colliding():
		destination = ray.get_collision_point()
	else:
		destination = to_global(ray.target_position)
	
	if tween == null or !tween.is_running():
		tween = create_tween()
		tween.tween_property(graphics, "global_position", destination, travel_time * to_local(destination).length() / ray.target_position.length())
		if !ray.get_collider().get_collision_layer_value(3):
			tween.tween_property(graphics, "global_position", hook_origin.global_position, travel_time * to_local(destination).length() / ray.target_position.length())
