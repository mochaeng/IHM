extends Control

@onready var buttons := $Buttons.get_children()


func _ready():
	Utils.processed_phase_buttons(buttons, Utils.phases_enable[0], Utils.phases_conclude[0])


func _on_phase_1_pressed():
	Utils.change_scene_with_transition("W1_L1")


func _on_phase_2_pressed():
	Utils.change_scene_with_transition("W1_L2")


func _on_phase_3_pressed():
	Utils.change_scene_with_transition("W1_L3")


func _on_back_button_pressed():
	Utils.change_scene_with_transition("WorldsSelection")
