extends "res://scripts/levels/normal_level.gd"

@onready var dialogue := $Dialogue
@onready var skip_button := $SkipButton

@onready var panel_bottom := $PanelBottom

enum Stage { CONVERSATION_1, ACTION_1 }
var stages_sequence = []
var stages_sequence_pointer = 0
var is_setting_stage = false
var current_stage

var path_to_dialogue: String
var textures_path = []


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


func _on_skip_button_pressed():
	dialogue.next_dialogue()


func _on_dialogue_dialogue_change():
	dialogue.set_dialogue(dialogue.get_current_dialogue_line())


func _on_dialogue_should_change_stage():
	stages_sequence_pointer += 1
	if stages_sequence_pointer >= stages_sequence.size():
		return
	is_setting_stage = true
	current_stage = stages_sequence[stages_sequence_pointer]
