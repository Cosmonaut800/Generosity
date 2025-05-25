extends AnimatableBody3D

@export var waypoints : Array[PlatformWaypoint] = []
@export var loop_path := true
@export var active := false

var tween : Tween = null

func _ready():
	if active: activate()

func activate() -> void:
		active = true
		tween = create_tween()
		if loop_path: tween.set_loops()
		for i in waypoints.size():
			tween.tween_property(self, "global_position", waypoints[i].global_position, waypoints[i].transit_time)
			tween.tween_interval(waypoints[i].wait_time)
	
