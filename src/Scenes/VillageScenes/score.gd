extends Control

@onready var label := $ColorRect/Score

func _ready():
	label.text = str(Utility.kodama_count)+"/6"
