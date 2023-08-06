extends StaticBody2D

class_name PlantTomatoSmall

signal watered

@onready var animation_player := $AnimationPlayer
@onready var sprite := $Sprite2D


func _ready():
	pass


func _process(_delta):
	pass


func _on_watered():
	print("I was watered")
	animation_player.play("blink")
	sprite.set_frame(10)
