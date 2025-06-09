class_name GameManager extends Node

var kodama_count := 0
var kodama_level := 0

func evaluate_kodama_level():
	if kodama_count < 1:
		kodama_level = 0
	if kodama_count >= 1:
		kodama_level = 1
	if kodama_count >= 3:
		kodama_level = 2
	if kodama_count >= 6:
		kodama_level = 3
	
	
