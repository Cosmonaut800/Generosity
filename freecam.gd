extends Node3D

@export var speed = 5.0

@onready var yaw_pivot := $YawPivot
@onready var pitch_pivot := $YawPivot/PitchPivot
@onready var cam := $YawPivot/PitchPivot/Camera3D

var focused = true

func _process(delta):
	var direction2 := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction := Vector3(direction2.x, 0.0, direction2.y)
	direction = yaw_pivot.basis * (pitch_pivot.basis * direction)
	
	if Input.is_action_pressed("ui_up"):
		speed += 20.0 * delta
	if Input.is_action_pressed("ui_down"):
		speed -= 20.0 * delta
	
	if Input.is_action_pressed("ui_right"):
		cam.fov += 20.0 * delta
	if Input.is_action_pressed("ui_left"):
		cam.fov -= 20.0 * delta
	
	if direction2:
		position += speed * delta * direction
	
	if Input.is_action_just_pressed("ui_cancel"):
		if focused:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		
		focused = !focused
	
	if not focused and Input.is_action_just_pressed("primary_fire"):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		focused = true

func _unhandled_input(event):
		if event is InputEventMouseMotion:
			if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
				yaw_pivot.rotate_y(-event.relative.x * 0.002)
				pitch_pivot.rotate_x(-event.relative.y * 0.002)
