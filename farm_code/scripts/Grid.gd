extends Node2D


func _ready():
	pass


func _process(_delta):
	pass

func _draw() -> void:
	# vertical lines
	for i in Utils.CELLS_AMOUNT.x:
		var from := Vector2(i * Utils.CELL_SIZE.x, 0)
		var to := Vector2(from.x, Utils.GRID_SIZE.y)
		draw_line(from, to, Color.BLACK)

	# horinzontal lines
	for i in Utils.CELLS_AMOUNT.y:
		var from := Vector2(0, Utils.CELL_SIZE.y * i)
		var to := Vector2(Utils.GRID_SIZE.x, from.y)
		draw_line(from, to, Color.BLACK)



