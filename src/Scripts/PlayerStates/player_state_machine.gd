extends StateMachine

@onready var player := $".."
@onready var player_grounded := $PlayerGrounded
@onready var player_aerial := $PlayerAerial
@onready var player_focused := $PlayerFocused

func _ready():
	current_state = player_grounded
	current_state.initialize(self)

func _physics_process(delta):
	current_state = current_state.run_current_state(delta)
