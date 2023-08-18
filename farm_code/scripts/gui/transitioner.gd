extends CanvasLayer

@onready var animation_player := $AnimationPlayer

func _ready():
	print(animation_player)
	print(self.get_children())

func change_scene_with_transition(target: String) -> void:
	animation_player.play("fade_out")
	await animation_player.animation_finished
	get_tree().change_scene_to_file(target)
	animation_player.play("fade_in")
	await animation_player.animation_changed
