extends Node

signal songs_option_change

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

var is_songs_enable := true


func _ready():
	Input.set_custom_mouse_cursor(arrow_cursor)
	Input.set_custom_mouse_cursor(pointing_hand_cursor, Input.CURSOR_POINTING_HAND)
	Input.set_custom_mouse_cursor(arrow_cursor, Input.CURSOR_FORBIDDEN)


func set_is_songs_enable(value: bool):
	is_songs_enable = value
