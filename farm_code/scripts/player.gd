extends CharacterBody2D

@export var speed = 300.0
@export var wallk_speed = 4.0

@onready var initial_position = Vector2.ZERO
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var animation_state = animation_tree.get()

const TILE_SIZE = 102

var input_direction = Vector2.ZERO
var is_moving = false
var percent_move_to_next_tile = 0.0


func _physics_process(delta):
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	# var direction = Input.get_axis("ui_left", "ui_right")
	if not is_moving:
		process_player_input()
	elif input_direction != Vector2.ZERO:
		move(delta)
	else:
		is_moving = false

	print(input_direction)
	# var direction: Vector2 = Input.get_vector("left", "right", "up", "down").normalized()

	# if direction:
	# 	velocity = direction * speed
	# else:
	# 	velocity = Vector2.ZERO

	# move_and_slide()

func process_player_input():
	if input_direction.y == 0:
		input_direction.x = int(Input.is_action_pressed("right")) - int(Input.is_action_pressed("left"))
	if input_direction.x == 0:
		input_direction.y = int(Input.is_action_pressed("down")) - int(Input.is_action_pressed("up"))
	
	if input_direction != Vector2.ZERO:
		initial_position = position
		is_moving = true

func move(delta):
	percent_move_to_next_tile += wallk_speed * delta
	if percent_move_to_next_tile >= 1.0:
		position = initial_position + (TILE_SIZE * input_direction)
		percent_move_to_next_tile = 0.0
		is_moving = false
	else:
		position = initial_position + (TILE_SIZE * input_direction * percent_move_to_next_tile)
