extends Control

@onready var audio_music := $AudioStreamPlayer
@onready var settings_window := $SettingsWindow


func _process(_delta):
	# audio_music.playing = Utils.is_songs_enable
	pass


func _ready():
	audio_music.playing = Utils.is_songs_enable
	settings_window.visible = false
	# Utils.should_close_settings.connect(clean_setting_window())
	Utils.songs_option_change.connect(toggle_music)


func toggle_music(is_enable: bool):
	# audio_music.playing = is_enable
	audio_music.playing = is_enable
	# audio_music.stream_paused = is_enable


func _on_start_button_pressed():
	Utils.change_scene_with_transition("WorldsSelection")


func _on_button_2_pressed():
	get_tree().change_scene_to_file("res://scenes/tutorial/levels/tutorial1.tscn")


func _on_credit_button_pressed():
	OS.shell_open("https://youtu.be/vy78mRq3wUI")


func _on_settings_button_pressed():
	settings_window.visible = true


func clean_setting_window():
	print("vou limpar")


func _on_settings_window_should_close_settings():
	settings_window.visible = false
