class_name PlayerFocused extends State

var pivot_tween: Tween

var unfocus_camera := false

func initialize(parent_machine: StateMachine):
	parent = parent_machine
	unfocus_camera = false
	if pivot_tween: pivot_tween.kill()
	pivot_tween = create_tween()
	pivot_tween.tween_property(parent.player.camera.camera.ray, "position", Vector3(parent.player.camera.SHOULDER_POS.x, parent.player.camera.SHOULDER_POS.y, -0.5), 0.1)
	pivot_tween.parallel().tween_property(parent.player.camera.camera, "position", parent.player.camera.SHOULDER_POS, 0.1)
	pivot_tween.parallel().tween_property(parent.player.camera.camera.target, "position", parent.player.camera.SHOULDER_POS, 0.1)
	pivot_tween.parallel().tween_property(parent.player.camera.yaw_pivot, "position", Vector3(0.0, parent.player.camera.yaw_pivot.position.y, 0.0), 0.1)
	parent.player.camera.camera.ray.target_position.z = parent.player.camera.SHOULDER_POS.z
	parent.player.camera.camera.hooke = 10.0
	parent.player.camera.focused = true
	parent.player.accel = 0.0

func run_current_state(delta: float):
	
	if unfocus_camera:
		if pivot_tween: pivot_tween.kill()
		pivot_tween = create_tween()
		pivot_tween.set_ease(Tween.EASE_OUT)
		pivot_tween.tween_property(parent.player.camera.camera.ray, "position", Vector3.ZERO, 0.1)
		parent.player.camera.camera.target.position = Vector3(0.0, 0.0, parent.player.camera.ORBIT_DISTANCE)
		parent.player.camera.camera.ray.target_position = parent.player.camera.camera.target.position
		parent.player.camera.camera.hooke = 2.0
		parent.player.camera.focused = false
		parent.player.accel = parent.player.ground_accel
		
		parent.player_grounded.initialize(parent)
		return parent.player_grounded
	
	parent.player.decelerate(delta)
	
	return self

func _input(event):
	if event.is_action_released("focus_camera"):
		unfocus_camera = true
