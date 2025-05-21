class_name State extends Node

var parent
var next_state

func initialize(parent_machine: StateMachine):
	parent = parent_machine

func run_current_state(delta: float) -> State:
	print("run_current_state() called from base State class!")
	return self
