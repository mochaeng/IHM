extends Node2D

@onready var player: Player = $Player

var is_processing_commands = false

var commands = []


func _process(_delta):
	pass


func process_commands():
	is_processing_commands = true

	for dir in commands:
		print(dir)
		player.move_by_direction(dir)
		await get_tree().create_timer(1).timeout

	is_processing_commands = false

func _on_button_pressed():
	print(commands)
	if not is_processing_commands:
		process_commands()


func _on_panel_queue_block_added(data: Block):
	commands.push_back(data.category)
