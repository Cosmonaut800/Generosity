extends Area3D

func _ready():
	self.body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node3D):
	body.respawn()
