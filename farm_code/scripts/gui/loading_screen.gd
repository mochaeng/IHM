extends CanvasLayer

class_name LoadingScreen

signal safe_to_load

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func fade_out_loading_screen():
	animation_player.play("fade_out")
	await animation_player.animation_finished
	queue_free()
