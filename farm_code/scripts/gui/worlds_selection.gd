extends Control

@onready var world_1 = $World1
@onready var world_2 = $World2
@onready var world_3 = $World3
@onready var settings_window := $SettingsWindow


func _ready():
	world_1.get_node("Name").text = "Mundo 1"
	world_2.get_node("Name").text = "Mundo 2"
	world_3.get_node("Name").text = "Mundo 3"

	settings_window.visible = false


func _on_settings_button_pressed():
	settings_window.visible = true


func _on_settings_window_should_close_settings():
	settings_window.visible = false


func _on_back_button_pressed():
	Utils.change_scene_with_transition("MenuScreen")


func _on_world1_play_button_pressed():
	Utils.change_scene_with_transition("Phases_1_Selection")
