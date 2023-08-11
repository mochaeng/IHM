extends Control

class_name Dialogue

signal dialogue_change
signal should_change_stage

@onready var dialogue

var npc_textures = []
var dialogue_file: FileAccess
var current_dialogue_line = 0
var content


func _process(_delta):
	pass


func _ready():
	current_dialogue_line = 0


func next_dialogue():
	if current_dialogue_line >= 0 && current_dialogue_line < content.size():
		current_dialogue_line += 1
		if current_dialogue_line == content.size():
			current_dialogue_line -= 1

		dialogue_change.emit()


func initiate(path: String, textures_path):
	load_file(path)
	load_npc_textures(textures_path)


func load_file(path: String):
	dialogue_file = FileAccess.open(path, FileAccess.READ)
	var file_content = dialogue_file.get_as_text()
	var dictionary_content = JSON.parse_string(file_content)
	content = dictionary_content


func load_npc_textures(textures: Array):
	for texture in textures:
		var texture_loaded = load(texture)
		npc_textures.append(texture_loaded)


func set_dialogue(line: Dictionary) -> void:
	$Name.text = line["name"]
	$Chat.text = line["text"]
	$Sprite2D.texture = npc_textures[line["frame"]]


func get_current_dialogue_line():
	assert(content != null, "Error: You should iniate the dialogue before getting its content")
	if content[current_dialogue_line]["is_disruptive"]:
		should_change_stage.emit()
	return content[current_dialogue_line]
