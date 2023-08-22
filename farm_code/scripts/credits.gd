extends Control


func _on_git_button_pressed():
	OS.shell_open("https://github.com/mochaeng/IHM")


func _on_back_button_pressed():
	Utils.change_scene_with_transition("MenuScreen")
