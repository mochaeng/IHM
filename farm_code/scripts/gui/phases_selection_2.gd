extends Control

@onready var buttons := $Buttons.get_children()


func _ready():
	print(buttons)
	Utils.processed_phase_buttons(buttons, Utils.phases_enable[1], Utils.phases_conclude[1])


func _on_phase_1_pressed():
	Utils.change_scene_with_transition("W2_L1")


func _on_phase_2_pressed():
	Utils.change_scene_with_transition("W2_L2")


func _on_back_button_pressed():
	Utils.change_scene_with_transition("WorldsSelection")
