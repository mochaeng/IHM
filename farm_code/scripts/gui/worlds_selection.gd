extends Control

@onready var world_1 = $World1
@onready var world_2 = $World2
@onready var world_3 = $World3

func _ready():
	world_1.get_node("Name").text = "Mundo 1"
	world_2.get_node("Name").text = "Mundo 2"
	world_3.get_node("Name").text = "Mundo 3"
