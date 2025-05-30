class_name PlayerPushing extends State

var collision : KinematicCollision3D = null
var target_pushable : CharacterBody3D = null
var stopped_pushing := false

func initialize(parent_machine: StateMachine):
	parent = parent_machine
	stopped_pushing = false
	target_pushable = parent.player.pushable_ray.get_collider()
	parent.player.speed = parent.player.pushing_speed
	parent.player.anim_tree.set("parameters/conditions/grounded", true)
	parent.player.anim_tree.set("parameters/conditions/aerial", false)

func run_current_state(delta: float) -> State:
	parent.player.graphics.look_at(parent.player.position - parent.player.pushable_ray.get_collision_normal())
	
	if !parent.player.pushable_ray.is_colliding():
		parent.player_grounded.initialize(parent)
		parent.player.anim_tree.set("parameters/conditions/pushing", false)
		return parent.player_grounded
	
	if !parent.player.is_on_floor():
		parent.player_aerial.initialize(parent)
		parent.player.anim_tree.set("parameters/conditions/pushing", false)
		return parent.player_aerial
	
	if Input.is_action_just_pressed("jump"):
		parent.player.velocity.y += parent.player.JUMP_VELOCITY
		parent.player_aerial.initialize(parent)
		parent.player.anim_tree.set("parameters/conditions/pushing", false)
		return parent.player_aerial
	
	if target_pushable.is_on_floor():
		var creep_distance : Vector3 = 0.85 * parent.player.pushable_ray.target_position - parent.player.to_local(parent.player.pushable_ray.get_collision_point())
		if creep_distance.dot(parent.player.pushable_ray.target_position) > 0.0:
			target_pushable.move_and_collide(Vector3(0.0, 0.1, 0.0))
			target_pushable.move_and_collide(creep_distance.dot(parent.player.pushable_ray.get_collision_normal()) * parent.player.pushable_ray.get_collision_normal())
			target_pushable.move_and_collide(Vector3(0.0, -0.1, 0.0))
	
	if !parent.player.direction:
		parent.player.decelerate(delta)
		parent.player.anim_tree.set("parameters/conditions/idling", true)
		parent.player.anim_tree.set("parameters/conditions/pushing", false)
	else:
		parent.player.anim_tree.set("parameters/conditions/idling", false)
		parent.player.anim_tree.set("parameters/conditions/pushing", true)
	
	if Input.is_action_pressed("focus_camera"):
		parent.player_focused.initialize(parent)
		parent.player.anim_tree.set("parameters/conditions/pushing", false)
		return parent.player_focused
	
	return self


func _on_push_timer_timeout() -> void:
	stopped_pushing = true
