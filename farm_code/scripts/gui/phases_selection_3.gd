extends Control

@onready var buttons := $Buttons.get_children()


func _ready():
	print(buttons)
	Utils.processed_phase_buttons(buttons, Utils.phases_enable[2], Utils.phases_conclude[2])


func _on_phase_1_pressed():
	Utils.change_scene_with_transition("W3_L1")


func _on_phase_2_pressed():
	Utils.change_scene_with_transition("W3_L2")


func _on_back_button_pressed():
	Utils.change_scene_with_transition("WorldsSelection")
