extends CharacterBody3D

const JUMP_VELOCITY = 4.5

@export var ground_speed := 5.0
@export var focused_speed := 2.0
@export var pushing_speed := 2.0
@export var ground_accel := 25.0
@export var air_accel := 5.0
@export var decel := 25.0
@export var camera : OrbitCamera
@export var hook_origin : Node3D
@export var anim_tree : AnimationTree


@onready var graphics := $Graphics
@onready var model := $Graphics/WolfTraveller
@onready var coyote_time := $CoyoteTime
@onready var push_timer := $PushTimer
@onready var pushable_ray := $PushableRay
@onready var crosshair := $UI/Crosshair
@onready var blackout := $UI/Black
@onready var kodama_text := $UI/KodamaText
@onready var footsteps: Array[AudioStreamPlayer3D] =\
[	$Audio/Step1,
	$Audio/Step2,
	$Audio/Step3,
	$Audio/Step4]

var speed := 5.0
var accel = 25.0
var direction : Vector3
var grappling_hook : Node3D
var pushable : RigidBody3D = null
var push_force := 1000.0
var respawn_position := Vector3.ZERO
var kodama_count := 0
var can_anything := true

func _ready():
	accel = ground_accel
	speed = ground_speed
	grappling_hook = camera.grappling_hook
	grappling_hook.hook_origin = hook_origin
	respawn_position = global_position

func _physics_process(delta):
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	direction = (camera.yaw_pivot.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	direction.y = 0.0
	if !can_anything: direction = Vector3.ZERO
	if direction:
		velocity.x = move_toward(velocity.x, speed * direction.x, (abs(direction.x) if abs(direction.x) > 0.3 else 0.3) * accel * delta)
		velocity.z = move_toward(velocity.z, speed * direction.z, (abs(direction.z) if abs(direction.z) > 0.3 else 0.3) * accel * delta)
		pushable_ray.target_position = direction * 1.0
	
	var displacement : Vector3 = (global_position - grappling_hook.graphics.global_position)
	if grappling_hook.status == grappling_hook.GRAPPLE:
		velocity -= 3.5 * displacement.length() * delta * displacement.normalized()
	if grappling_hook.status == grappling_hook.PULL:
		var distance : float = clamp(displacement.length(), 0.0, 10.0)
		grappling_hook.target.velocity += 8.0 * distance * delta * displacement.normalized()
	if grappling_hook.status == grappling_hook.PULL_PHYSICAL:
		grappling_hook.target.set_axis_lock(PhysicsServer3D.BODY_AXIS_ANGULAR_X, false)
		grappling_hook.target.set_axis_lock(PhysicsServer3D.BODY_AXIS_ANGULAR_Y, false)
		grappling_hook.target.set_axis_lock(PhysicsServer3D.BODY_AXIS_ANGULAR_Z, false)
		grappling_hook.target.apply_force(8.0 * displacement, grappling_hook.attach_point.global_position - grappling_hook.target.global_position)
	
	move_and_slide()
	
	if global_position.y < -50.0:
		global_position = Vector3(0.0, 100.0, 0.0)

func decelerate(delta):
	velocity.x = move_toward(velocity.x, 0, abs(velocity.normalized().x) * decel * delta)
	velocity.z = move_toward(velocity.z, 0, abs(velocity.normalized().z) * decel * delta)

func fire_grappling_hook():
	camera.grappling_hook.fire()

func respawn():
	var tween = create_tween()
	tween.tween_property(blackout, "color", Color(0.0, 0.0, 0.0, 1.0), 0.5)
	tween.tween_interval(0.25)
	tween.tween_callback(set_global_position.bind(respawn_position))
	tween.tween_interval(0.25)
	tween.tween_property(blackout, "color", Color(0.0, 0.0, 0.0, 0.0), 0.5)

func play_footstep():
	var index = randi_range(0, footsteps.size()-1)
	footsteps[index].pitch_scale = randf_range(0.9, 1.1)
	footsteps[index].play()
