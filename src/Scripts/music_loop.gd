extends Node3D

@onready var music_loop := $MusicLoop

func _on_music_intro_finished() -> void:
	print("Music loop started!")
	music_loop.play()
