extends Panel


func _on_back_button_pressed():
	Transitioner.change_scene_with_transition("res://scenes/gui/menu_screen.tscn")
