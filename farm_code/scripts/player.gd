extends CharacterBody2D

class_name Player

@export var speed = 300.0
@export var wallk_speed = 2.0

# @onready var initial_position = Vector2.ZERO
@onready var animation_tree: AnimationTree = $AnimationTree

const TILE_SIZE = 102

var input_direction = Vector2.ZERO
var is_moving = false
var percent_move_to_next_tile = 0.0
var initial_position = Vector2.ZERO

var directions = {
	"left": Vector2(-1, 0),
	"right": Vector2(1, 0),
	"up": Vector2(0, -1),
	"down": Vector2(0, 1),
}


func _ready():
	animation_tree.active = true


func update_animation_parameters():
	animation_tree["parameters/conditions/is_idle"] = not is_moving
	animation_tree["parameters/conditions/is_walking"] = is_moving

	if input_direction != Vector2.ZERO:
		animation_tree["parameters/Idle/blend_position"] = input_direction
		animation_tree["parameters/Walk/blend_position"] = input_direction
		animation_tree["parameters/Watering/blend_position"] = input_direction


func _process(_delta):
	update_animation_parameters()


func _physics_process(delta):
	if not is_moving:
		process_player_input()
	elif input_direction != Vector2.ZERO:
		move(delta)
	else:
		is_moving = false

	# print(input_direction)
	# var direction: Vector2 = Input.get_vector("left", "right", "up", "down").normalized()

	# if direction:
	# 	velocity = direction * speed
	# else:
	# 	velocity = Vector2.ZERO

	# move_and_slide()


func move_by_direction(direction: String):
	var vec_dir = directions[direction]

	if input_direction.y == 0:
		input_direction.x += vec_dir.x
		# input_direction.x = (
		# 	int(Input.is_action_pressed("right")) - int(Input.is_action_pressed("left"))
		# )
	if input_direction.x == 0:
		input_direction.y += vec_dir.y
		# input_direction.y = (
		# 	int(Input.is_action_pressed("down")) - int(Input.is_action_pressed("up"))
		# )

	if input_direction != Vector2.ZERO:
		initial_position = position
		is_moving = true


func process_player_input():
	if input_direction.y == 0:
		input_direction.x = (
			int(Input.is_action_pressed("right")) - int(Input.is_action_pressed("left"))
		)
	if input_direction.x == 0:
		input_direction.y = (
			int(Input.is_action_pressed("down")) - int(Input.is_action_pressed("up"))
		)


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
