extends Node2D

signal clean_panel

@onready var player: Player = $Player
@onready var label_text := $MissionIndicator.get_node("Label")

@onready var entities := $Entities.get_children()
@onready var total_amount := $Entities.get_children().size()
@onready var panel_queue := $PanelBottom.get_node("PanelQueue")

var entities_completed := 0
var is_processing_commands = false
var commands = []
var formatter := ": {completed}/{total}"


func _ready():
	update_label()


func update_label():
	label_text.text = formatter.format({"completed": entities_completed, "total": total_amount})


func process_commands():
	is_processing_commands = true

	for dir in commands:
		print(dir)
		player.move_by_direction(dir)
		await get_tree().create_timer(1).timeout

	await get_tree().create_timer(0.5).timeout

	if entities_completed != total_amount:
		get_tree().reload_current_scene()
	else:
		Utils.set_has_conclude_phase(1, 0, true)
		Utils.set_has_enable_phase(1, 1, true)
		Utils.change_scene_with_transition("W2_L2")

	is_processing_commands = false


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


func _on_plant_tomato_small_completed():
	if entities_completed <= total_amount:
		entities_completed += 1
		update_label()
