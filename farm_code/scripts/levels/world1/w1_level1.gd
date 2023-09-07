extends "res://scripts/levels/tutorial_level.gd"


func _init():
	stages_sequence = [Stage.CONVERSATION_1, Stage.ACTION_1]
	current_stage = Stage.CONVERSATION_1
	path_to_dialogue = "res://art/resources/dialogues/w1_l1.json"

	textures_path = [
		"res://art/npcs/emylly_normal.png",
		"res://art/npcs/emylly_shy.png",
		"res://art/npcs/emylly_surprise.png",
		"res://art/npcs/emylly_helping.png"
	]


func _ready():
	dialogue.initiate(path_to_dialogue, textures_path)
	dialogue.set_dialogue(dialogue.get_current_dialogue_line())
	update_label()

	dialogue.visible = false

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


func _on_static_body_2d_completed():
	if entities_completed <= total_amount:
		entities_completed += 1
		update_label()


func completed_level():
	Utils.set_has_conclude_phase(0, 0, true)
	Utils.set_has_enable_phase(0, 1, true)
	Utils.change_scene_with_transition("W1_L2")
