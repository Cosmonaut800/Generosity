extends CanvasLayer

@onready var lvl_select_list := $Control/MarginContainer/HBoxContainer/LevelSelect
@onready var lvl_select_bg := $Control/LevelSelectBG

signal level_changed(index: int, config: int)

func start_level(index: int, config: int):
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	level_changed.emit(index, config)
	

func _on_start_button_pressed() -> void:
	start_level(0, 1)

func _on_level_select_pressed() -> void:
	lvl_select_list.visible = !lvl_select_list.visible 
	lvl_select_bg.visible = !lvl_select_bg.visible 

func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_intro_pressed() -> void:
	start_level(0, 1)


func _on_level_1_pressed() -> void:
	start_level(1, 0)


func _on_level_2_pressed() -> void:
	start_level(2, 0)


func _on_level_3_pressed() -> void:
	start_level(3, 0)
