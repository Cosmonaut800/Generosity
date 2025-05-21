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

func _unhandled_input(event):
		if event is InputEventMouseMotion:
			if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
				yaw_input = -event.relative.x * mouse_sensitivity
				pitch_input = -event.relative.y * mouse_sensitivity
			
			yaw_pivot.rotate_y(yaw_input)
			pitch_pivot.rotate_x(pitch_input)
			pitch_pivot.rotation.x = clamp(pitch_pivot.rotation.x, -1.5, 1.5)
