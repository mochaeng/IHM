extends Node2D

signal clean_panel

@onready var player: Player = $Player

@onready var entities := $Entities.get_children()
@onready var total_amount := $Entities.get_children().size()

@onready var dialogue := $Dialogue
@onready var skip_button := $SkipButton
@onready var panel_show_buttons := $PanelShowButtons

enum Stage { CONVERSATION_1, CONVERSATION_2, ACTION_1 }

var is_processing_commands = false
var commands = []
var is_setting_stage = false

var stages_sequence_pointer = 0
var stages_sequence = [Stage.CONVERSATION_1, Stage.CONVERSATION_2, Stage.ACTION_1]
var current_stage = Stage.CONVERSATION_1

var path_to_dialogue = "res://art/resources/dialogues/tutorial_01.json"
var textures_path = [
	"res://art/npcs/emylly_normal.png",
	"res://art/npcs/emylly_shy.png",
	"res://art/npcs/emylly_surprise.png",
	"res://art/npcs/emylly_helping.png"
]


func _ready():
	dialogue.initiate(path_to_dialogue, textures_path)
	dialogue.set_dialogue(dialogue.get_current_dialogue_line())


func _process(_delta):
	match current_stage:
		Stage.CONVERSATION_1:
			if is_setting_stage:
				set_conversation_1()
				is_setting_stage = false
		Stage.CONVERSATION_2:
			if is_setting_stage:
				set_conversation_2()
				is_setting_stage = false
		Stage.ACTION_1:
			if is_setting_stage:
				set_action_1()
				is_setting_stage = false


func set_conversation_1():
	enable_dialogue_mode()
	panel_show_buttons.visible = false


func set_conversation_2():
	panel_show_buttons.visible = true


func set_action_1():
	disable_dialogue_mode()
	panel_show_buttons.visible = false


func enable_dialogue_mode():
	dialogue.position = Vector2(0, 42)
	skip_button.position = Vector2(2, 107)
	# dialogue.visible = true
	# skip_button.disabled = false


func disable_dialogue_mode():
	print(dialogue.position)
	dialogue.position = Vector2(0, 200)
	skip_button.position = Vector2(2, 200)
	# dialogue.visible = false
	# skip_button.disabled = true


func process_commands():
	is_processing_commands = true

	for dir in commands:
		print(dir)
		player.move_by_direction(dir)
		await get_tree().create_timer(1).timeout

	await get_tree().create_timer(0.5).timeout
	is_processing_commands = false


func _on_button_pressed():
	print(commands)
	if not is_processing_commands:
		process_commands()


func _on_panel_queue_block_added(data: Block):
	commands.push_back(data.category)


func _on_skip_button_pressed():
	print("change")
	dialogue.next_dialogue()


func _on_dialogue_dialogue_change():
	dialogue.set_dialogue(dialogue.get_current_dialogue_line())


func _on_dialogue_should_change_stage():
	stages_sequence_pointer += 1
	if stages_sequence_pointer >= stages_sequence.size():
		return
	is_setting_stage = true
	current_stage = stages_sequence[stages_sequence_pointer]


func _on_panel_queue_clean_panel():
	if not is_processing_commands:
		commands = []
		clean_panel.emit()
