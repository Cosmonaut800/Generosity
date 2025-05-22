extends Node3D

@export var travel_time := 0.2

@onready var ray := $RayCast3D
@onready var graphics := $Graphics
@onready var rope := $RopeParent

var tween : Tween
var destination := Vector3.ZERO
var hook_origin : Node3D
var attached := false
var attach_point := Vector3.ZERO

func _ready():
	graphics.hide()
	rope.hide()

func _process(_delta):
	rope.global_position = hook_origin.global_position
	rope.look_at(graphics.global_position)
	rope.set_scale(Vector3(1.0, 1.0, (hook_origin.global_position - graphics.global_position).length()))
	
	if attached:
		graphics.global_position = attach_point
		if Input.is_action_just_released("fire"):
			if tween == null or !tween.is_running():
				tween = create_tween()
				detach()
				tween.tween_property(graphics, "global_position", hook_origin.global_position, travel_time * to_local(destination).length() / ray.target_position.length())
				tween.tween_callback(hide_hook)

func _physics_process(delta):
	pass

func fire():
	if ray.is_colliding():
		destination = ray.get_collision_point()
	else:
		destination = to_global(ray.target_position)
	
	if tween == null or !tween.is_running():
		tween = create_tween()
		show_hook()
		if attached:
			detach()
			tween.tween_property(graphics, "global_position", hook_origin.global_position, travel_time * to_local(destination).length() / ray.target_position.length())
			tween.tween_callback(hide_hook)
		else:
			graphics.global_position = hook_origin.global_position
			tween.tween_property(graphics, "global_position", destination, travel_time * to_local(destination).length() / ray.target_position.length())
			if !ray.is_colliding() or !ray.get_collider().get_collision_layer_value(3):
				tween.tween_property(graphics, "global_position", hook_origin.global_position, travel_time * to_local(destination).length() / ray.target_position.length())
				tween.tween_callback(hide_hook)
			else:
				tween.tween_callback(attach_to_point.bind(ray.get_collision_point()))

func hide_hook() -> void:
	graphics.hide()
	rope.hide()

func show_hook() -> void:
	graphics.show()
	rope.show()

func attach_to_point(point: Vector3) -> void:
	attached = true
	attach_point = point

func detach() -> void:
	attached = false
