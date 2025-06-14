class_name PlayerFocused extends State

var pivot_tween: Tween

var mats = [preload("res://assets/Materials/interactable_column.tres"),
			preload("res://assets/Materials/interactable_rock.tres"),
			preload("res://assets/Materials/interactable_hook.tres"),
			preload("res://assets/Materials/interactable_switch.tres"),
			preload("res://assets/Materials/interactable_cog.tres"),
			preload("res://assets/Materials/interactable_tree.tres"),
			preload("res://assets/Materials/interactable_checker.tres")]

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
	for mat in mats:
		mat.set_shader_parameter("timeScale", 1.0)

func run_current_state(delta: float):
	parent.reset_anim_conditions()
	parent.player.anim_tree.set("parameters/conditions/grounded", true)
	parent.player.anim_tree.set("parameters/conditions/aiming", true)
	
	if !Input.is_action_pressed("focus_camera") or !parent.player.is_on_floor():
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
			parent.reset_anim_conditions()
			for mat in mats:
				mat.set_shader_parameter("timeScale", 0.0)
			return parent.player_grounded
		else:
			parent.player.crosshair.hide()
			parent.player_aerial.initialize(parent)
			parent.reset_anim_conditions()
			for mat in mats:
				mat.set_shader_parameter("timeScale", 0.0)
			return parent.player_aerial
	
	if parent.player.direction:
		parent.player.anim_tree.set("parameters/conditions/aiming", true)
		parent.player.anim_tree.set("parameters/conditions/walking", true)
	else:
		parent.player.anim_tree.set("parameters/conditions/aiming", true)
		parent.player.anim_tree.set("parameters/conditions/aimidling", true)
	
	parent.player.graphics.look_at(parent.player.grappling_hook.to_global(parent.player.grappling_hook.ray.target_position) * Vector3(1.0, 0.0, 1.0) + Vector3(0.0, parent.player.position.y, 0.0))
	
	if parent.player.can_anything and Input.is_action_just_pressed("fire"):
		parent.player.fire_grappling_hook()
	
	if !parent.player.direction: parent.player.decelerate(delta)
	
	return self
