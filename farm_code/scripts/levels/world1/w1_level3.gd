extends "res://scripts/levels/normal_level.gd"

func _ready():
	_initiate()


func completed_level():
	Utils.set_has_conclude_phase(0, 2, true)
	Utils.set_has_enable_phase(1, 0, true)
	Utils.set_has_conclude_world(0, true)
	Utils.set_has_enable_world(1, true)
	Utils.change_scene_with_transition("WorldsSelection")


func _on_static_body_2d_completed():
	if entities_completed <= total_amount:
		entities_completed += 1
		update_label()
