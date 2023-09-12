extends "res://scripts/levels/normal_level.gd"

func _ready():
	_initiate()

func completed_level():
	Utils.set_has_conclude_phase(2, 0, true)
	Utils.set_has_enable_phase(2, 1, true)
	Utils.change_scene_with_transition("W3_L2")


func _on_plant_tomato_small_completed():
	if entities_completed <= total_amount:
		entities_completed += 1
		update_label()


func _on_wood_1_completed():
	if entities_completed <= total_amount:
		entities_completed += 1
		update_label()
