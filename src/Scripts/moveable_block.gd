extends CharacterBody3D

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var respawn_position := Vector3.ZERO

func _ready():
	respawn_position = global_position

func _physics_process(delta):
	if !is_on_floor():
		velocity.y -= delta * gravity
	
	velocity.x = move_toward(velocity.x, 0, abs(velocity.normalized().x) * 25.0 * delta)
	velocity.z = move_toward(velocity.z, 0, abs(velocity.normalized().z) * 25.0 * delta)
	
	move_and_slide()

func respawn():
	global_position = respawn_position
