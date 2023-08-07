extends StaticBody2D

class_name PlantTomatoSmall

signal watered
signal completed

@onready var animation_player := $AnimationPlayer
@onready var sprite := $Sprite2D

var is_completed := false


func _ready():
	pass


func _process(_delta):
	pass


func completed_action():
	await get_tree().create_timer(0.5).timeout
	completed.emit()


func _on_watered():
	print("I was watered")
	animation_player.play("blink")
	sprite.set_frame(10)
