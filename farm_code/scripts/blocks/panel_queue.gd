extends Panel

class_name PanelQueue

signal block_added(data: Block)

@onready var block = preload("res://scenes/blocks/block.tscn")

@onready var right_texture = preload("res://art/blocks/right.png")
@onready var left_texture = preload("res://art/blocks/left.png")
@onready var up_texture = preload("res://art/blocks/up.png")
@onready var down_texture = preload("res://art/blocks/down.png")

var textures = {}


func _can_drop_data(_at_position, data):
	return data is Block == true


func _drop_data(_at_position, data):
	var new_block := block.instantiate()
	new_block.get_node("image").texture = textures[data.category]

	$Container.add_child(new_block)

	block_added.emit(data)


func _ready():
	textures["left"] = left_texture
	textures["right"] = right_texture
	textures["up"] = up_texture
	textures["down"] = down_texture


func _process(_delta):
	pass
