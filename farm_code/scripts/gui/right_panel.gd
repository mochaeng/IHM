extends Panel

signal category_clicked

@onready var buttons := self.get_children()


func _ready():
	print(buttons)
	for button in buttons:
		button.connect("pressed", handle_button_click)


func handle_button_click():
	print("I was clicked")
