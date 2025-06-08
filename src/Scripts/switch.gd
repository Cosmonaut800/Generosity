extends Node3D

@export var toggle := false

@onready var sfx := $AudioStreamPlayer3D

var is_active := false

signal activated(switch: Node3D)
signal deactivated(switch: Node3D)

func activate() -> void:
	
	if !is_active:
		is_active = true
		sfx.play()
		activated.emit(self)
	elif toggle:
		is_active = false
		deactivated.emit(self)
