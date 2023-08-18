extends Control


@onready var audio_music := $AudioStreamPlayer

func _process(_delta):
	pass

func _ready():
	audio_music.playing = Utils.is_songs_enable


func _on_button_pressed():
	Transitioner.change_scene_with_transition("res://scenes/levels/level1.tscn")


func _on_button_2_pressed():
	get_tree().change_scene_to_file("res://scenes/tutorial/levels/tutorial1.tscn")


func _on_credit_button_pressed():
	OS.shell_open("https://youtu.be/vy78mRq3wUI")
