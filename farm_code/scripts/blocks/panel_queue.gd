extends Panel

class_name PanelQueue

signal block_added(data: Block)
signal clean_panel

@onready var block = preload("res://scenes/blocks/block.tscn")

@onready var right_texture = preload("res://art/blocks/right.png")
@onready var left_texture = preload("res://art/blocks/left.png")
@onready var up_texture = preload("res://art/blocks/up.png")
@onready var down_texture = preload("res://art/blocks/down.png")
@onready var minus_90_texture = preload("res://art/blocks/turn_minus.png")
@onready var plus_90_texture = preload("res://art/blocks/turn_plus.png")
@onready var water_texture = preload("res://art/blocks/watering_can.png")

var textures = {}


func _can_drop_data(_at_position, data):
	return (data is Block == true) && data.category != ""


func _drop_data(_at_position, data):
	var new_block := block.instantiate()
	new_block.get_node("image").texture = textures[data.category]
	new_block.get_node("image").set_offset(Vector2(7, 0))
	new_block.set_custom_minimum_size(Vector2(64, 64))

	$Container.add_child(new_block)

	block_added.emit(data)


func _ready():
	textures["left"] = left_texture
	textures["right"] = right_texture
	textures["up"] = up_texture
	textures["down"] = down_texture
	textures["minus_90"] = minus_90_texture
	textures["plus_90"] = plus_90_texture
	textures["water"] = water_texture


func _process(_delta):
	pass


func _on_game_level_clean_panel():
	var blocks := $Container.get_children()
	var container := $Container
	for block_ in blocks:
		container.remove_child(block_)
		block_.call_deferred("queue_free")
