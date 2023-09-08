extends Panel

class_name PanelQueue

signal block_added(data: Block)
signal panel_clened
signal last_block_deleted

@onready var block = preload("res://scenes/blocks/block.tscn")

@onready var right_texture = preload("res://art/blocks/right.png")
@onready var left_texture = preload("res://art/blocks/left.png")
@onready var up_texture = preload("res://art/blocks/up.png")
@onready var down_texture = preload("res://art/blocks/down.png")
@onready var minus_90_texture = preload("res://art/blocks/turn_minus.png")
@onready var plus_90_texture = preload("res://art/blocks/turn_plus.png")
@onready var water_texture = preload("res://art/blocks/watering_can.png")

var textures = {}

var blocks_inside = []


func _ready():
	textures["left"] = left_texture
	textures["right"] = right_texture
	textures["up"] = up_texture
	textures["down"] = down_texture
	textures["minus_90"] = minus_90_texture
	textures["plus_90"] = plus_90_texture
	textures["water"] = water_texture

	panel_clened.connect(clean_panel)
	last_block_deleted.connect(delete_last_block)


func _get_drag_data(at_position):
	print(at_position)
	var preview := self
	print("hi")
	print(preview in blocks_inside)
	# preview.modulate.a = .5
	set_drag_preview(preview)
	return preview


func _can_drop_data(_at_position, data):
	return (data is Block == true) && data.category != ""


func _drop_data(_at_position, data):
	var new_block := creating_block(data)
	add_to_panel(new_block)


func creating_block(data) -> Block:
	var new_block := block.instantiate()
	new_block.position = Vector2(500, 5)
	new_block.get_node("image").texture = data.get_node("image").texture
	new_block.get_node("image").hframes = data.get_node("image").hframes

	new_block.get_node("image").vframes = data.get_node("image").vframes
	if data.category == "water" or data.category == "axing":
		new_block.get_node("image").scale = Vector2(3.8, 3.95)
	else:
		new_block.get_node("image").scale = Vector2(0.2, 0.2)

	new_block.get_node("image").frame = data.get_node("image").frame
	new_block.category = data.category
	new_block.set_custom_minimum_size(Vector2(64, 64))

	return new_block


func add_block_visually(block_to_add: Block):
	var new_block := creating_block(block_to_add)
	add_to_panel(new_block)


func add_to_panel(block_to_add: Block):
	$Container.add_child(block_to_add)
	block_added.emit(block_to_add)
	blocks_inside.push_back(block_to_add)


func clean_panel():
	var blocks := $Container.get_children()
	var container := $Container
	for block_ in blocks:
		container.remove_child(block_)
		block_.call_deferred("queue_free")


func delete_last_block():
	var idx = blocks_inside.size() - 1
	if idx < 0:
		return

	var block_to_remove = blocks_inside[idx]
	block_to_remove.call_deferred("queue_free")
	blocks_inside.remove_at(idx)
