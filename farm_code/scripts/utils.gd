extends Node

signal songs_option_change(option)

const SCENES_PATH = {
	"WorldsSelection": "res://scenes/gui/WorldsSelection.tscn",
	"MenuScreen": "res://scenes/gui/menu_screen.tscn",
	"Phase1": "res://scenes/levels/level1.tscn"
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
var phases_world_1_enable_status = [true, false]
var phases_world_1_conclude_status = [false, false]

var is_world_2_unlock = false
var is_world_3_unlock = false


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
