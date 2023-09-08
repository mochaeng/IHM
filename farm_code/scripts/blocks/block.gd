extends Button

class_name Block

signal block_clicked(block: Block)

@export var category = ""


func _get_drag_data(_at_position):
	var preview := self.duplicate()
	# preview.modulate.a = .5
	set_drag_preview(preview)

	return self


func _on_pressed() -> void:
	print('emitindo: ' + category)
	block_clicked.emit(self)
