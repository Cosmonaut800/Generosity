class_name PlayerAerial extends State

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func initialize(parent_machine: StateMachine):
	parent = parent_machine
	parent.player.accel = parent.player.air_accel

func run_current_state(delta: float) -> State:
	parent.reset_anim_conditions()
	parent.player.anim_tree.set("parameters/conditions/aerial", true)
	
	parent.player.velocity.y -= gravity * delta
	
	if parent.player.is_on_floor():
		parent.player_grounded.initialize(parent)
		return parent.player_grounded
	return self
