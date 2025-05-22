extends CharacterBody3D

const JUMP_VELOCITY = 4.5

@export var ground_speed := 5.0
@export var focused_speed := 2.0
@export var ground_accel := 25.0
@export var air_accel := 5.0
@export var decel := 25.0
@export var camera : OrbitCamera
@export var hook_origin : Node3D

@onready var graphics := $Graphics
@onready var coyote_time := $CoyoteTime

var speed := 5.0
var accel = 25.0
var direction : Vector3
var grappling_hook : Node3D

func _ready():
	accel = ground_accel
	speed = ground_speed
	grappling_hook = camera.grappling_hook
	grappling_hook.hook_origin = hook_origin

func _physics_process(delta):
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	direction = (camera.yaw_pivot.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	direction.y = 0.0
	if direction:
		velocity.x = move_toward(velocity.x, speed * direction.x, (abs(direction.x) if abs(direction.x) > 0.3 else 0.3) * accel * delta)
		velocity.z = move_toward(velocity.z, speed * direction.z, (abs(direction.z) if abs(direction.z) > 0.3 else 0.3) * accel * delta)
		graphics.look_at(position + (velocity * Vector3(1.0, 0.0, 1.0)))
	
	var displacement : Vector3 = (grappling_hook.graphics.global_position - global_position)
	if grappling_hook.attached:
		velocity += 3.0 * displacement.length() * delta * displacement.normalized()
	
	move_and_slide()
	
	if global_position.y < -50.0:
		global_position = Vector3(0.0, 100.0, 0.0)

func decelerate(delta):
	velocity.x = move_toward(velocity.x, 0, abs(velocity.normalized().x) * decel * delta)
	velocity.z = move_toward(velocity.z, 0, abs(velocity.normalized().z) * decel * delta)

func fire_grappling_hook():
	camera.grappling_hook.fire()
