extends Node3D

var player_nearby := false
var player : Node3D = null

func _input(event):
	if player_nearby and event.is_action_pressed("fire"):
		increment_kodama_count()

func increment_kodama_count() -> void:
	player.kodama_count += 1
	print(player.kodama_count)
	self.queue_free()

func _on_area_3d_body_entered(body: Node3D) -> void:
	player = body
	player_nearby = true

func _on_area_3d_body_exited(body: Node3D) -> void:
	player_nearby = false
