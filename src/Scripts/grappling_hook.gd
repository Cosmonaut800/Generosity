extends Node3D

@export var travel_time := 0.2

@onready var ray := $RayCast3D
@onready var graphics := $Graphics
@onready var hitbox := $StaticBody3D

var tween : Tween
var destination := Vector3.ZERO
var hook_origin : Node3D

func _ready():
	graphics.position = to_local(hook_origin.global_position)

func _physics_process(delta):
	pass

func fire():
	if ray.is_colliding():
		destination = to_local(ray.get_collision_point())
	else:
		destination = ray.target_position
	
	if tween == null or !tween.is_running():
		tween = create_tween()
		tween.tween_property(graphics, "position", destination, travel_time * destination.length() / ray.target_position.length())
		tween.parallel().tween_property(hitbox, "position", destination, travel_time * destination.length() / ray.target_position.length())
		tween.tween_property(graphics, "position", to_local(hook_origin.global_position), travel_time * destination.length() / ray.target_position.length())
		tween.parallel().tween_property(hitbox, "position", to_local(hook_origin.global_position), travel_time * destination.length() / ray.target_position.length())
