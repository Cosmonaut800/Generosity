class_name LevelTransition extends Area3D

@export var level_index := 0

signal level_changed(index: int)

func _ready():
	self.body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node3D):
	level_changed.emit(level_index)
