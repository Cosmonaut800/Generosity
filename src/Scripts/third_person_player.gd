extends CharacterBody3D

const JUMP_VELOCITY = 4.5

@export var speed = 5.0
@export var accel = 25.0
@export var decel = 25.0
@export var camera : OrbitCamera

@onready var graphics := $Graphics

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction = (camera.yaw_pivot.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	direction.y = 0.0
	if direction:
		velocity.x = move_toward(velocity.x, speed * direction.x, accel * delta)
		velocity.z = move_toward(velocity.z, speed * direction.z, accel * delta)
		graphics.look_at(position + (velocity * Vector3(1.0, 0.0, 1.0)))
	else:
		velocity.x = move_toward(velocity.x, 0, decel * delta)
		velocity.z = move_toward(velocity.z, 0, decel * delta)
	
	
	move_and_slide()
	
	if global_position.y < -50.0:
		global_position = Vector3(0.0, 100.0, 0.0)
