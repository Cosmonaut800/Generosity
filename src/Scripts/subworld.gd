extends Node3D

signal world_changed(index: int, config: int)

func _on_level_transition_level_changed(index: int, config: int) -> void:
	world_changed.emit(index, config)
