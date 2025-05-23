class_name PlayerPushing extends State

var collision : KinematicCollision3D = null
var target_pushable : CharacterBody3D = null
var stopped_pushing := false

func initialize(parent_machine: StateMachine):
	print("PUSHING STATE ENTERED")
	parent = parent_machine
	stopped_pushing = false
	target_pushable = parent.player.pushable_ray.get_collider()

func run_current_state(delta: float) -> State:
	parent.player.graphics.look_at(parent.player.position - parent.player.pushable_ray.get_collision_normal())
	
	if !parent.player.pushable_ray.is_colliding():
		parent.player_grounded.initialize(parent)
		return parent.player_grounded
	
	if target_pushable.is_on_floor():
		#target_pushable.velocity = -parent.player.pushable_ray.get_collision_normal() * parent.player.speed * 0.5
		#target_pushable.move_and_collide(delta * parent.player.velocity)
		var creep_distance : Vector3 = 0.75 * parent.player.pushable_ray.target_position - parent.player.to_local(parent.player.pushable_ray.get_collision_point())
		if parent.player.direction and parent.player.get_real_velocity().length() < 0.95 * parent.player.speed:
				target_pushable.move_and_collide(delta * 1.5 * parent.player.velocity.dot(parent.player.pushable_ray.get_collision_normal()) * parent.player.pushable_ray.get_collision_normal())
		elif creep_distance.dot(parent.player.pushable_ray.target_position) > 0.0:
			target_pushable.move_and_collide(creep_distance.dot(parent.player.pushable_ray.get_collision_normal()) * parent.player.pushable_ray.get_collision_normal())
	
	parent.player.decelerate(delta)
	
	return self


func _on_push_timer_timeout() -> void:
	stopped_pushing = true
