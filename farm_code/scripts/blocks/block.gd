extends Panel

class_name Block

@export var category = ""


func _get_drag_data(_at_position):
	var preview := self.duplicate()
	# preview.modulate.a = .5

	set_drag_preview(preview)

	return preview


# Called when the node enters the scene tree for the first time.
func _ready():
	pass  # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
