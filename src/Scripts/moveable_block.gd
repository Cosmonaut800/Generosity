extends CharacterBody3D

@onready var sfx := $AudioStreamPlayer3D

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var respawn_position := Vector3.ZERO
var last_position := Vector3.ZERO
var sfx_pos := 0.0

func _ready():
	respawn_position = global_position
	last_position = position

func _physics_process(delta):
	last_position.y = position.y
	if !is_on_floor():
		velocity.y -= delta * gravity
		if sfx.playing:
			sfx_pos = sfx.get_playback_position()
			sfx.stop()
	elif last_position.distance_squared_to(position)/delta > 0.05:
		if !sfx.playing:
			sfx.play(sfx_pos)
	else:
		if sfx.playing:
			sfx_pos = sfx.get_playback_position()
			sfx.stop()
	last_position = position
	
	velocity.x = move_toward(velocity.x, 0, abs(velocity.normalized().x) * 25.0 * delta)
	velocity.z = move_toward(velocity.z, 0, abs(velocity.normalized().z) * 25.0 * delta)
	
	move_and_slide()

func respawn():
	global_position = respawn_position
