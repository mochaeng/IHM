extends Control

@onready var buttons := $Buttons.get_children()


func _ready():
	Utils.processed_phase_buttons(buttons)


func _on_phase_1_pressed():
	Utils.change_scene_with_transition("Phase1")


func _on_phase_2_pressed():
	Utils.change_scene_with_transition("Phase2")
