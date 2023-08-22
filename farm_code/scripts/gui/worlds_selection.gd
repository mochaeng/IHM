extends Control

@onready var worlds := $Worlds.get_children()
@onready var settings_window := $SettingsWindow


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

		idx += 1

	settings_window.visible = false

	# var quantity_completed_1 = Utils.get_phases_completed_from_world(Utils.phases_world_1_conclude_status)
	# var quantity_completed_2 = Utils.get_phases_completed_from_world(Utils.phases_world_2_conclude_status)

	# world_1.get_node("Quantity").text = quantity_completed_1 + " " + Utils.phases_world_1_conclude_status.size()
	# world_2.get_node("Quantity").text = quantity_completed_2 + " " + Utils.phases_world_2_conclude_status.size()


func _on_settings_button_pressed():
	settings_window.visible = true


func _on_settings_window_should_close_settings():
	settings_window.visible = false


func _on_back_button_pressed():
	Utils.change_scene_with_transition("MenuScreen")


func _on_world1_play_button_pressed():
	Utils.change_scene_with_transition("Phases_1_Selection")


func _on_world2_play_button_pressed():
	Utils.change_scene_with_transition("Phases_2_Selection")
