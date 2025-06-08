extends Node3D

@export var stay_activated := true

@onready var button_graphics := $BaseGraphics/ButtonGraphics
@onready var sfx := $AudioStreamPlayer3D

var is_active := false
var button_default_height := 0.1

signal activated(button: Node3D)
signal deactivated(button: Node3D)

func _ready():
	button_default_height = button_graphics.position.y

func activate() -> void:
	is_active = true
	activated.emit(self)
	var tween = create_tween()
	tween.tween_property(button_graphics, "position:y", button_default_height - 0.12, 0.1)
	sfx.play()

func deactivate() -> void:
	is_active = false
	deactivated.emit(self)
	var tween = create_tween()
	tween.tween_property(button_graphics, "position:y", button_default_height, 0.1)

func _on_area_3d_body_entered(body: Node3D) -> void:
	if !is_active: activate()

func _on_area_3d_body_exited(body: Node3D) -> void:
	if ! stay_activated: deactivate()
