extends Node2D

signal clean_panel

@onready var player: Player = $Player
@onready var label_text := $MissionIndicator.get_node("Label")

@onready var entities := $Entities.get_children()
@onready var total_amount := $Entities.get_children().size()
@onready var panel_queue := $PanelBottom.get_node("PanelQueue")

@onready var dialogue := $Dialogue
@onready var skip_button := $SkipButton

@onready var panel_bottom := $PanelBottom

enum Stage { CONVERSATION_1, ACTION_1 }
var is_setting_stage = false

var stages_sequence_pointer = 0
var stages_sequence = [Stage.CONVERSATION_1, Stage.ACTION_1]
var current_stage = Stage.CONVERSATION_1

var path_to_dialogue = "res://art/resources/dialogues/w1_l1.json"
var textures_path = [
	"res://art/npcs/emylly_normal.png",
	"res://art/npcs/emylly_shy.png",
	"res://art/npcs/emylly_surprise.png",
	"res://art/npcs/emylly_helping.png"
]
var entities_completed := 0
var is_processing_commands = false
var commands = []
var formatter := ": {completed}/{total}"


func _ready():
	dialogue.initiate(path_to_dialogue, textures_path)
	dialogue.set_dialogue(dialogue.get_current_dialogue_line())
	update_label()

	dialogue.visible = false
	print("é chamada no reload")

	if Utils.showed_dialogues[0]:
		_on_dialogue_should_change_stage()
	else:
		dialogue.visible = true


func _process(_delta):
	match current_stage:
		Stage.CONVERSATION_1:
			if is_setting_stage:
				set_conversation_1()
				is_setting_stage = false
		Stage.ACTION_1:
			Utils.set_has_showed_dialogues(0, true)
			if is_setting_stage:
				set_action_1()
				is_setting_stage = false


func set_conversation_1():
	enable_dialogue_mode()


func set_action_1():
	disable_dialogue_mode()
	# panel_bottom.visible = true


func enable_dialogue_mode():
	dialogue.position = Vector2(0, 42)
	skip_button.position = Vector2(2, 107)


func disable_dialogue_mode():
	dialogue.position = Vector2(0, 200)
	skip_button.position = Vector2(2, 200)


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
		Utils.set_has_conclude_phase(0, 0, true)
		Utils.set_has_enable_phase(0, 1, true)
		Utils.change_scene_with_transition("W1_L2")

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


func _on_static_body_2d_completed():
	if entities_completed <= total_amount:
		entities_completed += 1
		update_label()


func _on_skip_button_pressed():
	dialogue.next_dialogue()


func _on_dialogue_dialogue_change():
	dialogue.set_dialogue(dialogue.get_current_dialogue_line())


func _on_dialogue_should_change_stage():
	print("Neve called")
	stages_sequence_pointer += 1
	if stages_sequence_pointer >= stages_sequence.size():
		return
	is_setting_stage = true
	current_stage = stages_sequence[stages_sequence_pointer]
