extends Node3D

@onready var text_box := $TextBox

signal level_changed(index: int, config: int)

func _on_entrance_timeout() -> void:
	text_box.display_text_box("LUMBERJACK_1")
	text_box.display_text_box("LUMBERJACK_2")

func _on_text_box_finished() -> void:
	print("Attempting level change")
	level_changed.emit(0, 2)
