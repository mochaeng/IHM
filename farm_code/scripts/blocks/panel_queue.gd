extends Panel

class_name PanelQueue

signal block_added(data: Block)
signal panel_clened

@onready var block = preload("res://scenes/blocks/block.tscn")

@onready var right_texture = preload("res://art/blocks/right.png")
@onready var left_texture = preload("res://art/blocks/left.png")
@onready var up_texture = preload("res://art/blocks/up.png")
@onready var down_texture = preload("res://art/blocks/down.png")
@onready var minus_90_texture = preload("res://art/blocks/turn_minus.png")
@onready var plus_90_texture = preload("res://art/blocks/turn_plus.png")
@onready var water_texture = preload("res://art/blocks/watering_can.png")

var textures = {}


func _ready():
	textures["left"] = left_texture
	textures["right"] = right_texture
	textures["up"] = up_texture
	textures["down"] = down_texture
	textures["minus_90"] = minus_90_texture
	textures["plus_90"] = plus_90_texture
	textures["water"] = water_texture

	panel_clened.connect(clean_panel)


func _get_drag_data(_at_position):
	var preview := self.duplicate()
	# preview.modulate.a = .5
	set_drag_preview(preview)
	return preview


func _can_drop_data(_at_position, data):
	return (data is Block == true) && data.category != ""


func _drop_data(_at_position, data):
	var new_block := block.instantiate()

	# new_block.get_node("image").texture = textures[data.category]
	new_block.get_node("image").texture = data.get_node("image").texture
	new_block.get_node("image").hframes = data.get_node("image").hframes

	new_block.get_node("image").vframes = data.get_node("image").vframes
	if data.category == "watering" or data.category == "axing":
		new_block.get_node("image").scale = Vector2(3.8, 3.95)
	else:
		new_block.get_node("image").scale = Vector2(0.2, 0.2)

	new_block.get_node("image").frame = data.get_node("image").frame
	new_block.category = data.category

	new_block.set_custom_minimum_size(Vector2(64, 64))

	$Container.add_child(new_block)

	block_added.emit(data)


func clean_panel():
	var blocks := $Container.get_children()
	var container := $Container
	for block_ in blocks:
		container.remove_child(block_)
		block_.call_deferred("queue_free")
