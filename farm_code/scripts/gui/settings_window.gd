extends CanvasLayer

class_name SettingsWindow

signal should_close_settings


func _on_back_button_pressed():
	print("hi")
	should_close_settings.emit()
