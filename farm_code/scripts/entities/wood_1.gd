extends StaticBody2D

signal interacted
signal completed

@onready var animation_player := $AnimationPlayer
@onready var sprite := $Sprite2D

var is_completed := false


func _ready():
	interacted.connect(interact_with)


func completed_action():
	print("FUI CHAMADA")
	if is_completed:
		return

	completed.emit()
	is_completed = true
	queue_free()


func interact_with():
	print("I was cuted")
	animation_player.play("blink")
	# sprite.set_frame(10)
