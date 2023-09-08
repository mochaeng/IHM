extends Panel

signal category_clicked

@onready var buttons := self.get_children()


func _ready():
	print(buttons)
