extends Node3D

@onready var text_box := $TextBox
@onready var blackout := $"../Control/ColorRect"
@onready var wolf1 := $"../WolfTraveller1"
@onready var wolf2 := $"../WolfTraveller2"

var step := 0

signal level_changed(index: int, config: int)

func _on_entrance_timeout() -> void:
	text_box.display_text_box("OLD_WOMAN_3")

func _on_text_box_finished() -> void:
	step += 1
	if step == 1:
		var tween = create_tween()
		tween.tween_property(blackout, "color", Color(0.0, 0.0, 0.0, 1.0), 0.5)
		tween.tween_interval(0.25)
		tween.tween_callback(wolf1.hide)
		tween.tween_callback(wolf2.show)
		tween.tween_interval(0.25)
		tween.tween_property(blackout, "color", Color(0.0, 0.0, 0.0, 0.0), 0.5)
		tween.tween_callback(text_box.display_text_box.bind("FAMILY_1"))
		tween.tween_callback(text_box.display_text_box.bind("FAMILY_2"))
		tween.tween_callback(text_box.display_text_box.bind("FAMILY_3"))
	level_changed.emit(0, 6)
