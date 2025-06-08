extends Node3D

@export var travel_time := 0.2

@onready var ray := $RayCast3D
@onready var graphics := $Graphics
@onready var rope := $RopeParent

var tween : Tween
var destination := Vector3.ZERO
var hook_origin : Node3D
var attached := false
var target : Node3D = null
var attach_point : Node3D = null
var status := 0

enum {FREE, GRAPPLE, PULL, PULL_PHYSICAL}

func _ready():
	graphics.hide()
	rope.hide()

func _process(_delta):
	rope.global_position = hook_origin.global_position
	rope.look_at(graphics.global_position)
	rope.set_scale(Vector3(1.0, 1.0, (hook_origin.global_position - graphics.global_position).length()))
	
	if attached:
		graphics.global_position = attach_point.global_position
		if !Input.is_action_pressed("fire"):
			if tween == null or !tween.is_running():
				tween = create_tween()
				detach()
				tween.tween_property(graphics, "global_position", hook_origin.global_position, travel_time * to_local(destination).length() / ray.target_position.length())
				tween.tween_callback(hide_hook)

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
			if !ray.is_colliding() or (!ray.get_collider().get_collision_layer_value(3) and !ray.get_collider().get_collision_layer_value(4) and !ray.get_collider().get_collision_layer_value(6) and !ray.get_collider().get_collision_layer_value(7)):
				tween.tween_property(graphics, "global_position", hook_origin.global_position, travel_time * to_local(destination).length() / ray.target_position.length())
				tween.tween_callback(hide_hook)
			else:
				if attach_point == null: attach_point = Node3D.new()
				target = ray.get_collider()
				target.add_child(attach_point)
				attach_point.global_position = ray.get_collision_point()
				print(global_position.distance_to(attach_point.global_position))
				tween.tween_callback(attach_to_point)

func hide_hook() -> void:
	graphics.hide()
	rope.hide()

func show_hook() -> void:
	graphics.show()
	rope.show()

func attach_to_point() -> void:
	attached = true
	if target.get_collision_layer_value(3):
		status = GRAPPLE
	elif target.get_collision_layer_value(4):
		target.activate()
	elif target.get_collision_layer_value(6):
		status = PULL
	elif target.get_collision_layer_value(7):
		status = PULL_PHYSICAL

func detach() -> void:
	attached = false
	attach_point.queue_free()
	status = FREE
