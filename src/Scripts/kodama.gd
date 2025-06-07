extends Node3D

var player_nearby := false
@export var player : Node3D = null
var true_position := Vector3.ZERO
var time := 0.0

func _ready():
	true_position = position

func _process(delta):
	if player:
		look_at(Vector3(player.global_position.x, global_position.y, player.global_position.z))
	time += delta
	position.y = true_position.y + 0.1 * sin(time)

func _input(event):
	if player_nearby and event.is_action_pressed("fire"):
		increment_kodama_count()

func increment_kodama_count() -> void:
	Utility.kodama_count += 1
	print(Utility.kodama_count)
	self.queue_free()

func _on_area_3d_body_entered(body: Node3D) -> void:
	player = body
	player_nearby = true

func _on_area_3d_body_exited(_body: Node3D) -> void:
	player_nearby = false
