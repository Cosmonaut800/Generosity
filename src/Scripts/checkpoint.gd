class_name Checkpoint extends Area3D

@export var respawn_position : Node3D

func _ready():
	self.body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node3D):
	print("Respawn Point Set")
	body.respawn_position = respawn_position.global_position
