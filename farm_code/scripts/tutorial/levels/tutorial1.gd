extends Node2D

signal clean_panel

@onready var player: Player = $Player

@onready var entities := $Entities.get_children()
@onready var total_amount := $Entities.get_children().size()

@onready var dialogue := $Dialogue
@onready var skip_button := $SkipButton

enum Stage { SHOWING, TEXTING, DISABLING }

var current_stage = Stage.SHOWING
var entities_completed := 0
var is_processing_commands = false
var commands = []
var formatter := ": {completed}/{total}"
var path_to_dialogue = "res://art/resources/dialogues/tutorial_01.json"
var textures_path = [
	"res://art/npcs/emylly_normal.png",
	"res://art/npcs/emylly_shy.png",
	"res://art/npcs/emylly_surprise.png",
	"res://art/npcs/emylly_helping.png"
]


func _ready():
	# dialogue.load_file(path_to_dialogue)
	dialogue.initiate(path_to_dialogue, textures_path)
	dialogue.set_dialogue(dialogue.get_current_dialogue_line())


func _process(_delta):
	match current_stage:
		Stage.SHOWING:
			enable_dialogue_mode()
		Stage.TEXTING:
			pass
		Stage.DISABLING:
			disable_dialogue_mode()


func enable_dialogue_mode():
	dialogue.visible = true
	skip_button.disabled = false


func disable_dialogue_mode():
	dialogue.visible = false
	skip_button.disabled = true


func process_commands():
	is_processing_commands = true

	for dir in commands:
		print(dir)
		player.move_by_direction(dir)
		await get_tree().create_timer(1).timeout

	print("acabou")
	await get_tree().create_timer(0.5).timeout

	if entities_completed != total_amount:
		get_tree().reload_current_scene()
	else:
		get_tree().change_scene_to_file("res://scenes/levels/game_level.tscn")

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
