class_name PlayerGrounded extends State

var coyote_expired := false

func initialize(parent_machine: StateMachine):
	parent = parent_machine
	coyote_expired = false
	parent.player.accel = parent.player.ground_accel
	parent.player.speed = parent.player.ground_speed

func run_current_state(delta: float) -> State:
	if !parent.player.direction:
		parent.player.decelerate(delta)
	else:
		parent.player.graphics.look_at(parent.player.position + (parent.player.velocity * Vector3(1.0, 0.0, 1.0)))
	
	if parent.player.pushable_ray.is_colliding():
		print("Entering pushing state")
		parent.player_pushing.initialize(parent)
		return parent.player_pushing
	#if parent.player.get_slide_collision_count() > 0:
		#for i in parent.player.get_slide_collision_count():
			#var collision = parent.player.get_slide_collision(i)
			#if collision.get_collider() is RigidBody3D and collision.get_collider().get_collision_layer_value(5):
				#parent.player_pushing.collision = collision
				#parent.player_pushing.initialize(parent)
				#return parent.player_pushing
	
	if !parent.player.is_on_floor():
		if !coyote_expired and parent.player.coyote_time.is_stopped():
			parent.player.coyote_time.start()
		elif coyote_expired:
			parent.player_aerial.initialize(parent)
			return parent.player_aerial
	
	if Input.is_action_pressed("jump"):
		parent.player.velocity.y += parent.player.JUMP_VELOCITY
		parent.player_aerial.initialize(parent)
		return parent.player_aerial
	
	if Input.is_action_just_pressed("focus_camera"):
		parent.player_focused.initialize(parent)
		return parent.player_focused
	
	return self

func _on_coyote_time_timeout() -> void:
	coyote_expired = true
