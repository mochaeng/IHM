extends Button

class_name Block

@export var category = ""


func _get_drag_data(_at_position):
	var preview := self.duplicate()
	# preview.modulate.a = .5
	set_drag_preview(preview)

	return preview


func _on_pressed() -> String:
	return category
