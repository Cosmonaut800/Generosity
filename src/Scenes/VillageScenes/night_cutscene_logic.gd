extends Node3D

@onready var text_box := $TextBox

signal level_changed(index: int, config: int)

func _on_entrance_timeout() -> void:
	text_box.display_text_box("FAMILY_4")
	text_box.display_text_box("FAMILY_5")
	text_box.display_text_box("FAMILY_6")

func _on_text_box_finished() -> void:
	level_changed.emit(4, 5)
