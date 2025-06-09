class_name PlayerPushingRigidBody extends State

var collision : KinematicCollision3D = null
var target_pushable : RigidBody3D = null
var stopped_pushing := false

func initialize(parent_machine: StateMachine):
	parent = parent_machine
	stopped_pushing = false
	target_pushable = collision.get_collider()
	print("ENTERED PUSHING STATE")
	target_pushable.max_contacts_reported = 16
	target_pushable.contact_monitor = true
	target_pushable.add_constant_force(-200.0 * collision.get_normal())

func run_current_state(delta: float) -> State:
	var num_of_pushables := 0
	
	#target_pushable.linear_velocity = parent.player.direction * parent.player.speed * 0.5
	
	for body in target_pushable.get_colliding_bodies():
		if body == parent.player:
			print("player still touching")
			num_of_pushables += 1
	
	if num_of_pushables == 0 and parent.player.push_timer.is_stopped():
		parent.player.push_timer.start()
	
	if stopped_pushing:
		target_pushable.set_constant_force(Vector3.ZERO)
		target_pushable.max_contacts_reported = 0
		target_pushable.contact_monitor = false
		parent.player_grounded.initialize(parent)
		return parent.player_grounded
	
	return self


func _on_push_timer_timeout() -> void:
	stopped_pushing = true
