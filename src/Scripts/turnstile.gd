extends Node3D

@onready var body := $RigidBody3D
@onready var sfx := $RigidBody3D/SFX

func _physics_process(_delta):
	if body.angular_velocity.length() > 0.01:
		sfx.pitch_scale = clamp(body.angular_velocity.length()/1.093, 0.0, 0.3)
		if !sfx.playing:
			sfx.play()
	else:
		sfx.stop()
