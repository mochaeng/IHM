extends Control



func _on_back_button_pressed():
	Utils.change_scene_with_transition("MenuScreen")


func _on_yt_button_pressed():
	OS.shell_open("https://youtu.be/UdJ2T_Ygqg0")
