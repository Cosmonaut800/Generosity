extends Node3D

@onready var move_jump := $"../Tutorial/MoveJumpBox"
@onready var grappling_hook := $"../Tutorial/GrapplingHookBox"
@onready var interactable := $"../Tutorial/InteractablesBox"
@onready var tut_timer := $"../TutorialTimer"

func _on_tutorial_area_body_entered(_body: Node3D) -> void:
	move_jump.hide()
	grappling_hook.show()

func _on_tutorial_area_2_body_entered(_body: Node3D) -> void:
	grappling_hook.hide()
	interactable.show()
	tut_timer.start()

func _on_tutorial_timer_timeout() -> void:
	move_jump.hide()
	grappling_hook.hide()
	interactable.hide()
