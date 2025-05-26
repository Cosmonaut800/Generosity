extends Node3D

signal reset
signal world_changed(index: int)

func _input(event):
	if event.is_action_pressed("reset"):
		reset.emit()

func _on_level_transition_level_changed(index: int) -> void:
	world_changed.emit(index)
