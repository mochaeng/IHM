extends Node

signal songs_option_change(option)

const SCENES_PATH = {
	"WorldsSelection": "res://scenes/gui/WorldsSelection.tscn",
	"MenuScreen": "res://scenes/gui/menu_screen.tscn",
	"Phase1": "res://scenes/levels/level1.tscn",
	"Phase2": "res://scenes/levels/level2.tscn",
	"Phases_1_Selection": "res://scenes/gui/phases_selection_1.tscn",
	"Phases_2_Selection": "res://scenes/gui/phases_selection_2.tscn",
	"W1_L1": "res://scenes/levels/world1/w1_level1.tscn",
	"W1_L2": "res://scenes/levels/world1/w1_level2.tscn",
	"W1_L3": "res://scenes/levels/world1/w1_level3.tscn",
	"W2_L1": "res://scenes/levels/world2/w2_level1.tscn",
	"W2_L2": "res://scenes/levels/world2/w2_level2.tscn",
}

const GRID_SIZE := Vector2(800, 600)
const CELL_SIZE := Vector2(16, 16)
const CELLS_AMOUNT := Vector2(GRID_SIZE.x / CELL_SIZE.x, GRID_SIZE.y / CELL_SIZE.y)

const BLACK := Color("23213D")
const GRAY := Color("B9B5C3")
const WHITE := Color.WHITE

var arrow_cursor = load("res://art/cat_UI/Sprite sheets/Mouse sprites/Triangle Mouse icon 1.png")
var pointing_hand_cursor = load(
	"res://art/cat_UI/Sprite sheets/Mouse sprites/Catpaw pointing Mouse icon.png"
)

var holding_cursor = load(
	"res://art/cat_UI/Sprite sheets/Mouse sprites/Catpaw holding Mouse icon.png"
)
var is_songs_enable := false

var transitioner = preload("res://scenes/gui/transitioner.tscn")
var settings_window = preload("res://scenes/gui/settings_window.tscn")

# wolrds && phases
var phases_conclude = [[false, false, false], [false, false], [false, false]]
var phases_enable = [[true, false, false], [false, false], [false, false]]
# var phases_world_1_enable_status = [true, false]
# var phases_world_1_conclude_status = [false, false]

# var phases_world_2_enable_status = [false, false]
# var phases_world_2_conclude_status = [false, false]

var worlds_conclude = [false, false, false]
var worlds_enable = [true, false, false]


func set_has_conclude_phase(world: int, phase: int, value: bool):
	phases_conclude[world][phase] = value


func set_has_enable_phase(world: int, phase: int, value: bool):
	phases_enable[world][phase] = value


func set_has_conclude_world(world: int, value: bool):
	worlds_conclude[world] = value


func set_has_enable_world(world: int, value: bool):
	worlds_enable[world] = value


func get_phases_conclude_from_world(world: int) -> int:
	var quantity = 0
	for is_completed in phases_conclude[world]:
		if is_completed:
			quantity += 1
	return quantity


######


func _ready():
	Input.set_custom_mouse_cursor(arrow_cursor)
	Input.set_custom_mouse_cursor(pointing_hand_cursor, Input.CURSOR_POINTING_HAND)
	Input.set_custom_mouse_cursor(arrow_cursor, Input.CURSOR_FORBIDDEN)
	Input.set_custom_mouse_cursor(holding_cursor, Input.CURSOR_CAN_DROP)


func change_scene_with_transition(target: String) -> void:
	var transitioner_instance = transitioner.instantiate()
	var animation_player = transitioner_instance.get_node("AnimationPlayer")

	await get_tree().get_root().call_deferred("add_child", transitioner_instance)

	animation_player.play("fade_out")
	await animation_player.animation_finished

	if SCENES_PATH.has(target):
		target = SCENES_PATH[target]

	get_tree().change_scene_to_file(target)

	animation_player.play("fade_in")
	await animation_player.animation_changed

	get_tree().get_root().call_deferred("remove_child", transitioner_instance)
	transitioner_instance.call_deferred("queue_free")
	animation_player.call_deferred("queue_free")


func change_scene_with_loading(target: String) -> void:
	var transitioner_instance = transitioner.instantiate()
	var animation_player = transitioner_instance.get_node("AnimationPlayer")

	get_tree().get_root().call_deferred("add_child", transitioner_instance)

	animation_player.play("fade_out")
	await animation_player.animation_finished

	get_tree().change_scene_to_file(target)

	animation_player.play("fade_in")
	await animation_player.animation_changed
	transitioner_instance.call_deferred("queue_free")


func set_is_songs_enable(value: bool):
	is_songs_enable = value


const ENABLED_STAR_FRAME := 7
const DISABLED_STAR_FRAME := 9


func processed_phase_buttons(buttons: Array[Node], phases_enable_, phases_conclude_) -> void:
	print(phases_enable)

	var idx = 0
	for is_enable in phases_enable_:
		if is_enable:
			buttons[idx].get_node("Number").text = str(idx + 1)

		buttons[idx].disabled = not is_enable

		idx += 1

	idx = 0
	for is_concluded in phases_conclude_:
		var sprites := buttons[idx].get_node("Stars").get_children()
		for sprite in sprites:
			if not phases_enable_[idx]:
				sprite.visible = false
			elif is_concluded:
				sprite.frame = ENABLED_STAR_FRAME
			else:
				sprite.frame = DISABLED_STAR_FRAME

		idx += 1
