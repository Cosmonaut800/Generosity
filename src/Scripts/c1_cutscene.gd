extends Node3D

@onready var player := $"../ThirdPersonPlayer"
@onready var axe := $"../Axe"
@onready var text_box := $TextBox
@onready var timer := $Timer
@onready var kodama := $"../Kodama"
@onready var kodama_position := $"../KodamaPosition"

var already_happened := false
var step := 0

func _on_area_3d_body_entered(body: Node3D) -> void:
	if !already_happened:
		already_happened = true
		player.can_anything = false
		text_box.display_text_box("GOAL_1_1")

func _on_text_box_finished() -> void:
	step += 1
	if step == 1:
		timer.start()
		axe.hide()
		var tween = create_tween()
		tween.tween_property(kodama, "true_position", kodama_position.position, 1.0)
	elif step == 2:
		var tween = create_tween()
		tween.tween_interval(0.2)
		tween.tween_property(player, "can_anything", true, 0.0)

func _on_timer_timeout() -> void:
	text_box.display_text_box("GOAL_1_2")
	text_box.display_text_box("GOAL_1_3")
