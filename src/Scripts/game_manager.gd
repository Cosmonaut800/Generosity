class_name GameManager extends Node

var kodama_count := 0
var kodama_level := 0

func evaluate_kodama_level():
	if kodama_count < 1:
		kodama_level = 0
	elif kodama_count >= 1:
		kodama_level = 1
	elif kodama_count >= 3:
		kodama_level = 2
	elif kodama_count >= 6:
		kodama_level = 3
