extends Node3D

var player_nearby := false
@export var player : Node3D = null
var true_position := Vector3.ZERO
var time := 0.0

@export var world : Node3D

@onready var particles := $FragmentBurst
@onready var graphics := $Kodama

func _ready():
	true_position = position

func _process(delta):
	if player:
		look_at(Vector3(player.global_position.x, global_position.y, player.global_position.z))
		if player.can_anything:
			player.kodama_text.visible = player_nearby
		else:
			player.kodama_text.hide()
	time += delta
	position = Vector3(true_position.x, true_position.y + 0.1 * sin(time), true_position.z)

func _input(event):
	if player:
		if player.can_anything and player_nearby and event.is_action_pressed("fire"):
			increment_kodama_count()
			player_nearby = false
			var tween = create_tween()
			particles.burst()
			graphics.hide()
			tween.tween_interval(2.0)
			tween.tween_callback(queue_free)

func increment_kodama_count() -> void:
	Utility.kodama_count += 1
	world.kodama_count += 1

func _on_area_3d_body_entered(body: Node3D) -> void:
	player = body
	player_nearby = true

func _on_area_3d_body_exited(_body: Node3D) -> void:
	player_nearby = false
