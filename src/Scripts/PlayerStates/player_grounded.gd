class_name PlayerGrounded extends State

var coyote_expired := false
var focus_camera := false

func initialize(parent_machine: StateMachine):
	parent = parent_machine
	coyote_expired = false
	focus_camera = false
	parent.player.accel = parent.player.ground_accel
	parent.player.speed = parent.player.ground_speed

func run_current_state(delta: float) -> State:
	if !parent.player.direction:
		parent.player.decelerate(delta)
	
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
	
	if focus_camera:
		parent.player_focused.initialize(parent)
		return parent.player_focused
	
	return self

func _input(event):
	if event.is_action_pressed("focus_camera"):
		focus_camera = true

func _on_coyote_time_timeout() -> void:
	coyote_expired = true
