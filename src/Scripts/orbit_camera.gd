class_name OrbitCamera extends Node3D

@onready var actor: CharacterBody3D = get_parent()
@onready var yaw_pivot := $YawPivot
@onready var pitch_pivot := $YawPivot/PitchPivot

var mouse_sensitivity := 0.001
var yaw_input := 0.0
var pitch_input := 0.0

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _process(_delta):
	if Input.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _unhandled_input(event):
		if event is InputEventMouseMotion:
			if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
				yaw_input = -event.relative.x * mouse_sensitivity
				pitch_input = -event.relative.y * mouse_sensitivity
			
			yaw_pivot.rotate_y(yaw_input)
			pitch_pivot.rotate_x(pitch_input)
			pitch_pivot.rotation.x = clamp(pitch_pivot.rotation.x, -1.5, 1.5)
