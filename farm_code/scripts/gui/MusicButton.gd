extends Button

var off_theme: Theme = load("res://scenes/gui/themes/off_button.tres")
var on_theme: Theme = load("res://scenes/gui/themes/on_button.tres")

var is_active := false


func _ready():
	is_active = Utils.is_songs_enable
	change_texture()


func change_texture():
	print("Hi")
	if is_active:
		self.theme = on_theme
	else:
		self.theme = off_theme


func _on_pressed():
	is_active = not is_active
	Utils.set_is_songs_enable(is_active)
	change_texture()
