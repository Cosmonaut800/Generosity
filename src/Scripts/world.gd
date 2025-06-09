extends Node3D

@export var subworlds : Array[Resource]

var kodama_count := 0

signal reset
signal world_changed(index: int, config: int)

func _input(event):
	if event.is_action_pressed("reset"):
		Utility.kodama_count -= kodama_count
		reset.emit()

func _on_level_transition_level_changed(index: int, config: int) -> void:
	world_changed.emit(index, config)
