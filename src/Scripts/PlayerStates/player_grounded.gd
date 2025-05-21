class_name PlayerGrounded extends State

var coyote_expired := false

func initialize(parent_machine: StateMachine):
	parent = parent_machine
	coyote_expired = false
	parent.player.accel = parent.player.ground_accel

func run_current_state(delta: float) -> State:
	if !parent.player.direction:
		parent.player.velocity.x = move_toward(parent.player.velocity.x, 0, abs(parent.player.velocity.normalized().x) * parent.player.decel * delta)
		parent.player.velocity.z = move_toward(parent.player.velocity.z, 0, abs(parent.player.velocity.normalized().z) * parent.player.decel * delta)
	
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
	
	return self

func _on_coyote_time_timeout() -> void:
	coyote_expired = true
