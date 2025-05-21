extends Camera3D

const CHARACTER_MAX_DISTANCE := 0.3
const REGULAR_TARGET_DISTANCE := 5.0

@export var camera_radius : float = 0.3

@onready var ray := $"../CameraRay"
@onready var target := $"../CameraPosTarget"
@onready var yaw_pivot := $"../.."
@onready var root := $"../../.."
var distance := 4.6
var hooke := 2.0

func _ready():
	ray.target_position = position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var pivot_lateral_position := Vector2(yaw_pivot.position.x, yaw_pivot.position.z)
	
	if ray.is_colliding():
		#global_position = ray.get_collision_point()
		target.global_position = ray.get_collision_point()
		target.position -= camera_radius * ray.target_position.normalized()
	else:
		if root.focused:
			target.position.z = root.SHOULDER_POS.z
		else:
			target.position.z = root.ORBIT_DISTANCE
	
	global_position = global_position + (hooke * delta * (target.global_position - global_position))
	
	if !root.focused:
		if pivot_lateral_position.length() > CHARACTER_MAX_DISTANCE:
			pivot_lateral_position = pivot_lateral_position + (5.0 * hooke * delta * (CHARACTER_MAX_DISTANCE * pivot_lateral_position.normalized() - pivot_lateral_position))
			yaw_pivot.position = Vector3(pivot_lateral_position.x, yaw_pivot.position.y, pivot_lateral_position.y)
		yaw_pivot.position.y = yaw_pivot.position.y + (3.0 * hooke * delta * (0.8 - yaw_pivot.position.y))

func _physics_process(_delta):
	if !root.focused:
		yaw_pivot.position = yaw_pivot.position - root.actor.get_position_delta()
