extends GPUParticles3D

@onready var floaty := $Floaty

func burst():
	emitting = true
	floaty.emitting = true
