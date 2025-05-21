class_name OrbitCamera extends Node3D

const ORBIT_DISTANCE = 5.0
const SHOULDER_POS : Vector3 = Vector3(1.0, 0.0, 2.0)

@onready var actor: CharacterBody3D = get_parent()
@onready var yaw_pivot := $YawPivot
@onready var pitch_pivot := $YawPivot/PitchPivot
@onready var camera := $YawPivot/PitchPivot/Camera3D

var mouse_sensitivity := 0.001
var yaw_input := 0.0
var pitch_input := 0.0
var focused := false
var pivot_tween : Tween

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	if event.is_action_pressed("focus_camera"):
		if pivot_tween: pivot_tween.kill()
		pivot_tween = create_tween()
		pivot_tween.tween_property(camera.ray, "position", Vector3(SHOULDER_POS.x, SHOULDER_POS.y, -0.5), 0.1)
		pivot_tween.parallel().tween_property(camera, "position", SHOULDER_POS, 0.1)
		pivot_tween.parallel().tween_property(camera.target, "position", SHOULDER_POS, 0.1)
		pivot_tween.parallel().tween_property(yaw_pivot, "position", Vector3(0.0, yaw_pivot.position.y, 0.0), 0.1)
		camera.ray.target_position.z = SHOULDER_POS.z
		camera.hooke = 10.0
		focused = true
	elif event.is_action_released("focus_camera"):
		if pivot_tween: pivot_tween.kill()
		pivot_tween = create_tween()
		pivot_tween.set_ease(Tween.EASE_OUT)
		pivot_tween.tween_property(camera.ray, "position", Vector3.ZERO, 0.1)
		camera.target.position = Vector3(0.0, 0.0, ORBIT_DISTANCE)
		camera.ray.target_position = camera.target.position
		camera.hooke = 2.0
		focused = false

func _unhandled_input(event):
		if event is InputEventMouseMotion:
			if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
				yaw_input = -event.relative.x * mouse_sensitivity
				pitch_input = -event.relative.y * mouse_sensitivity
			
			yaw_pivot.rotate_y(yaw_input)
			pitch_pivot.rotate_x(pitch_input)
			pitch_pivot.rotation.x = clamp(pitch_pivot.rotation.x, -1.5, 1.5)
