extends Control

@onready var audio_music := $AudioStreamPlayer
@onready var settings_window := $SettingsWindow


func _ready():
	audio_music.playing = Utils.is_songs_enable
	settings_window.visible = false
	# Utils.should_close_settings.connect(clean_setting_window())
	Utils.songs_option_change.connect(toggle_music)

	# settings_window.get_node("Control/Panel/BackButton").connect("pressed", _on_settings_button_pressed)
	# settings_window.get_node("Control/Panel/MusicButton").connect("pressed", _on_settings_button_pressed)


func toggle_music(is_enable: bool):
	# audio_music.playing = is_enable
	audio_music.playing = is_enable
	# audio_music.stream_paused = is_enable


func _on_start_button_pressed():
	Utils.change_scene_with_transition("WorldsSelection")


func _on_credit_button_pressed():
	OS.shell_open("https://youtu.be/vy78mRq3wUI")


func _on_settings_button_pressed():
	settings_window.visible = true


func _on_settings_window_should_close_settings():
	settings_window.visible = false


func _on_tutorial_button_pressed():
	Utils.change_scene_with_transition("Instructions")


func _on_history_button_pressed():
	Utils.change_scene_with_transition("History_1")
