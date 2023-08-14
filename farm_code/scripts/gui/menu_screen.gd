extends Control


func _process(_delta):
	pass


func _on_button_pressed():
	get_tree().change_scene_to_file("res://scenes/levels/level1.tscn")


func _on_button_2_pressed():
	get_tree().change_scene_to_file("res://scenes/tutorial/levels/tutorial1.tscn")
