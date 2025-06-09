extends Node3D

@onready var player := $"../ThirdPersonPlayer"
@onready var text_box := $TextBox
@onready var herb := $"../InteractableModels/QuestFlower"

var already_happened := false

func _on_area_3d_body_entered(body: Node3D) -> void:
	if !already_happened:
		already_happened = true
		player.can_anything = false
		text_box.display_text_box("GOAL_2")

func _on_text_box_finished() -> void:
	player.can_anything = true
	herb.hide()
