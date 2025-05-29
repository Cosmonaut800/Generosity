class_name PlayerFocused extends State

var pivot_tween: Tween

func initialize(parent_machine: StateMachine):
	parent = parent_machine
	if pivot_tween: pivot_tween.kill()
	pivot_tween = create_tween()
	#pivot_tween.tween_property(parent.player.camera.camera.ray, "position", Vector3(parent.player.camera.SHOULDER_POS.x, parent.player.camera.SHOULDER_POS.y, -0.5), 0.1)
	#pivot_tween.parallel().tween_property(parent.player.camera.camera, "position", parent.player.camera.SHOULDER_POS, 0.1)
	pivot_tween.parallel().tween_property(parent.player.camera.camera.target, "position", parent.player.camera.SHOULDER_POS, 0.1)
	pivot_tween.parallel().tween_property(parent.player.camera.yaw_pivot, "position", Vector3(0.0, parent.player.camera.yaw_pivot.position.y, 0.0), 0.1)
	parent.player.camera.camera.ray.set_enabled(false)
	#parent.player.camera.camera.ray.target_position.z = parent.player.camera.SHOULDER_POS.z
	parent.player.camera.camera.hooke = 10.0
	parent.player.camera.focused = true
	parent.player.speed = parent.player.focused_speed
	parent.player.crosshair.show()
	parent.player.anim_tree.set("parameters/conditions/grounded", true)
	parent.player.anim_tree.set("parameters/conditions/aerial", false)	

func run_current_state(delta: float):
	
	if Input.is_action_just_released("focus_camera") or !parent.player.is_on_floor():
		if pivot_tween: pivot_tween.kill()
		pivot_tween = create_tween()
		pivot_tween.set_ease(Tween.EASE_OUT)
		pivot_tween.tween_property(parent.player.camera.camera.ray, "position", Vector3.ZERO, 0.1)
		parent.player.camera.camera.target.position = Vector3(0.0, 0.0, parent.player.camera.ORBIT_DISTANCE)
		parent.player.camera.camera.ray.set_enabled(true)
		#parent.player.camera.camera.ray.target_position = parent.player.camera.camera.target.position
		parent.player.camera.camera.hooke = 2.0
		parent.player.camera.focused = false
		parent.player.accel = parent.player.ground_accel
		
		if parent.player.is_on_floor():
			parent.player.crosshair.hide()
			parent.player_grounded.initialize(parent)
			parent.player.anim_tree.set("parameters/conditions/walking", false)
			return parent.player_grounded
		else:
			parent.player.crosshair.hide()
			parent.player_aerial.initialize(parent)
			return parent.player_aerial
	
	if parent.player.direction:
		parent.player.anim_tree.set("parameters/conditions/walking", true)
		parent.player.anim_tree.set("parameters/conditions/idling", false)
	else:
		parent.player.anim_tree.set("parameters/conditions/walking", false)
		parent.player.anim_tree.set("parameters/conditions/idling", true)
	
	parent.player.graphics.look_at(parent.player.grappling_hook.to_global(parent.player.grappling_hook.ray.target_position) * Vector3(1.0, 0.0, 1.0) + Vector3(0.0, parent.player.position.y, 0.0))
	
	if Input.is_action_just_pressed("fire"):
		parent.player.fire_grappling_hook()
	
	if !parent.player.direction: parent.player.decelerate(delta)
	
	return self
