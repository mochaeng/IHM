extends StaticBody2D

class_name PlantTomatoSmall

signal interacted
signal completed

@onready var animation_player := $AnimationPlayer
@onready var sprite := $Sprite2D
@onready var selection := $BlinkSelection

var is_completed := false


func _ready():
	interacted.connect(interact_with)


func completed_action():
	print("FUI CHAMADA")
	if is_completed:
		return

	completed.emit()
	is_completed = true


func interact_with():
	print("I was watered")
	animation_player.play("blink")
	sprite.set_frame(10)
	selection.visible = false
