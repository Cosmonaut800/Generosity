extends Node3D

@export var toggle := false

var is_active := false

signal activated(switch: Node3D)
signal deactivated(switch: Node3D)

func activate() -> void:
	if toggle:
		is_active = !is_active
	else:
		is_active = true
	
	if is_active:
		activated.emit(self)
	else:
		deactivated.emit(self)
