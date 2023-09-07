extends Node2D

signal clean_panel

@onready var player: Player = $Player
@onready var label_text := $MissionIndicator.get_node("Label")

@onready var entities := $Entities.get_children()
@onready var total_amount := $Entities.get_children().size()
@onready var panel_queue := $PanelBottom.get_node("PanelQueue")
@onready var right_panel := $RightPanel

var entities_completed := 0
var is_processing_commands = false
var commands = []
var formatter := ": {completed}/{total}"


func _ready():
	update_label()
	right_panel.get_node("RightBlock").connect("_on_pressed", test)


func test():
	print("recebi o sinal")


func update_label():
	label_text.text = formatter.format({"completed": entities_completed, "total": total_amount})


func process_commands():
	is_processing_commands = true

	before_processing_commands()

	for dir in commands:
		print(dir)
		player.move_by_direction(dir)
		await get_tree().create_timer(1).timeout

	await get_tree().create_timer(0.3).timeout

	after_processing_commands()

	if entities_completed != total_amount:
		player.emit_signal("sad_emoted")
		await player.sad_emoted
		get_tree().reload_current_scene()
	else:
		completed_level()

	is_processing_commands = false


func before_processing_commands():
	pass


func after_processing_commands():
	pass


func completed_level():
	pass


func not_completed_level():
	pass


func _on_panel_queue_block_added(data: Block):
	commands.push_back(data.category)


func _on_play_button_pressed():
	print(commands)
	if not is_processing_commands:
		process_commands()


func _on_clean_button_pressed():
	if not is_processing_commands:
		commands = []
		panel_queue.emit_signal("panel_clened")
