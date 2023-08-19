extends Control

@onready var audio_music := $AudioStreamPlayer


func _process(_delta):
	pass


func _ready():
	audio_music.playing = Utils.is_songs_enable


func _on_button_pressed():
	# Utils.load_scene(self, "res://scenes/levels/level1.tscn")
	Utils.change_scene_with_transition("res://scenes/levels/level1.tscn")


func _on_button_2_pressed():
	get_tree().change_scene_to_file("res://scenes/tutorial/levels/tutorial1.tscn")


func _on_credit_button_pressed():
	OS.shell_open("https://youtu.be/vy78mRq3wUI")


func _on_settings_button_pressed():
	var setting_window = load("res://scenes/gui/settings_window.tscn").instantiate()
	get_tree().get_root().call_deferred("add_child", setting_window)
	print(setting_window)
	# Transitioner.change_scene_with_transition("res://scenes/gui/settings_window.tscn")
