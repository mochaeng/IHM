extends Node2D

signal clean_panel

@onready var player: Player = $Player
@onready var label_text := $Panel.get_node("Label")

@onready var entities := $Entities.get_children()
@onready var total_amount := $Entities.get_children().size()

var entities_completed := 0
var is_processing_commands = false
var commands = []
var formatter := ": {completed}/{total}"


func _ready():
	update_label()


func _process(_delta):
	pass


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
		Utils.set_has_conclude_phase(Utils.phases_world_1_conclude_status, true, 0)
		Utils.set_has_enable_phase(Utils.phases_world_1_enable_status, true, 1)
		get_tree().change_scene_to_file("res://scenes/levels/level2.tscn")

	is_processing_commands = false


func _on_button_pressed():
	print(commands)
	if not is_processing_commands:
		process_commands()


func _on_panel_queue_block_added(data: Block):
	commands.push_back(data.category)


func _on_plant_tomato_small_1_completed():
	if entities_completed <= total_amount:
		entities_completed += 1
		update_label()


func _on_plant_tomato_small_2_completed():
	if entities_completed <= total_amount:
		entities_completed += 1
		update_label()


func _on_limpar_button_pressed():
	if not is_processing_commands:
		commands = []
		clean_panel.emit()
