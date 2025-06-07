extends StateMachine

@onready var player := $".."
@onready var player_grounded := $PlayerGrounded
@onready var player_aerial := $PlayerAerial
@onready var player_focused := $PlayerFocused
@onready var player_pushing := $PlayerPushing

func _ready():
	current_state = player_grounded
	current_state.initialize(self)

func _physics_process(delta):
	current_state = current_state.run_current_state(delta)

func reset_anim_conditions():
	player.anim_tree.set("parameters/conditions/grounded", false)
	player.anim_tree.set("parameters/conditions/aerial", false)
	player.anim_tree.set("parameters/conditions/idling", false)
	player.anim_tree.set("parameters/conditions/running", false)
	player.anim_tree.set("parameters/conditions/aiming", false)
	player.anim_tree.set("parameters/conditions/aimidling", false)
	player.anim_tree.set("parameters/conditions/walking", false)
	player.anim_tree.set("parameters/conditions/pushing", false)
