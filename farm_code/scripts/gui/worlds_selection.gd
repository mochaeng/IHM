extends Panel

@onready var worlds := $Worlds.get_children()


func _ready():
	var idx = 0
	for world in worlds:
		world.get_node("Name").text = "Mundo " + str(idx + 1)

		var quantity_conclude = Utils.get_phases_conclude_from_world(idx)
		world.get_node("Quantity").text = (
			str(quantity_conclude) + "/" + str(Utils.phases_conclude[idx].size())
		)

		if not Utils.worlds_enable[idx]:
			world.get_node("PlayButton").disabled = true
			world.get_node("InfoButton").disabled = true
			world.get_node("PlayButton").text = ""
			world.get_node("InfoButton").text = ""
			world.get_node("Quantity").visible = false
			world.get_node("Logo").visible = false

		idx += 1
	
		
	worlds[0].get_node("PlayButton").connect("pressed", _on_world1_play_button_pressed)
	worlds[1].get_node("PlayButton").connect("pressed", _on_world2_play_button_pressed)
	# worlds[2].get_node("PlayButton").connect("pressed", _on_world1_play_button_pressed)


func _on_back_button_pressed():
	Utils.change_scene_with_transition("MenuScreen")


func _on_world1_play_button_pressed():
	Utils.change_scene_with_transition("Phases_1_Selection")


func _on_world2_play_button_pressed():
	Utils.change_scene_with_transition("Phases_2_Selection")
