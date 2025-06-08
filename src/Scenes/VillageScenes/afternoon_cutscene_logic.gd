extends Node3D

@onready var text_box := $TextBox

signal level_changed(index: int, config: int)

func _on_entrance_timeout() -> void:
	text_box.display_text_box("OLD_WOMAN_3")
	text_box.display_text_box("FAMILY_1")
	text_box.display_text_box("FAMILY_2")
	text_box.display_text_box("FAMILY_3")

func _on_text_box_finished() -> void:
	level_changed.emit(0, 2)
