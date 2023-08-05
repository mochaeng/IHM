extends CharacterBody2D

class_name Player

@export var speed = 300.0
@export var wallk_speed = 2.0

# @onready var initial_position = Vector2.ZERO
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var animation_state = animation_tree.get("parameters/playback")
@onready var ray_cast: RayCast2D = $MoveRayCast2D

const TILE_SIZE = 16

enum PlayerState { IDLE, TURNING, WALKING, WATERING }
enum FacingDirection { LEFT, RIGHT, UP, DOWN }

var player_state := PlayerState.IDLE
var player_facing_direction := FacingDirection.DOWN

var input_direction = Vector2.ZERO
var is_moving = false
var is_watering = false
var percent_move_to_next_tile = 0.0
var initial_position = Vector2.ZERO

var directions = {
	"left": Vector2(-1, 0),
	"right": Vector2(1, 0),
	"up": Vector2(0, -1),
	"down": Vector2(0, 1),
	"minus_90": Vector2(0, 0),
	"empty": Vector2.ZERO
}


func _ready():
	animation_tree.active = true


func ___update_animation_parameters():
	animation_tree["parameters/conditions/is_idle"] = not is_moving
	animation_tree["parameters/conditions/is_walking"] = is_moving

	if input_direction != Vector2.ZERO:
		animation_tree["parameters/Idle/blend_position"] = input_direction
		animation_tree["parameters/Walk/blend_position"] = input_direction
		animation_tree["parameters/Watering/blend_position"] = input_direction


func _process(_delta):
	# update_animation_parameters()
	pass


func _physics_process(delta):
	if player_state == PlayerState.TURNING:
		return
	elif not is_moving:
		# input_direction = Vector2.ZERO
		# travel_logic_update()
		process_player_input()
	elif input_direction != Vector2.ZERO:
		animation_state.travel("Walk")
		move(delta)
	else:
		animation_state.travel("Idle")
		is_moving = false


func process_player_input():
	if input_direction.y == 0:
		input_direction.x = (
			int(Input.is_action_pressed("right")) - int(Input.is_action_pressed("left"))
		)
	if input_direction.x == 0:
		input_direction.y = (
			int(Input.is_action_pressed("down")) - int(Input.is_action_pressed("up"))
		)

	travel_logic_update()


func is_need_to_turn() -> bool:
	var new_facing_direction
	if input_direction.x < 0:
		new_facing_direction = FacingDirection.LEFT
	elif input_direction.x > 0:
		new_facing_direction = FacingDirection.RIGHT
	elif input_direction.y < 0:
		new_facing_direction = FacingDirection.UP
	elif input_direction.y > 0:
		new_facing_direction = FacingDirection.DOWN

	if player_facing_direction != new_facing_direction:
		player_facing_direction = new_facing_direction
		return true

	player_facing_direction = new_facing_direction
	return false

func turn_player():
	if input_direction.x < 0:
		player_facing_direction = FacingDirection.LEFT
	elif input_direction.x > 0:
		player_facing_direction = FacingDirection.RIGHT
	elif input_direction.y < 0:
		player_facing_direction = FacingDirection.UP
	elif input_direction.y > 0:
		player_facing_direction = FacingDirection.DOWN
	
	player_state = PlayerState.TURNING
	animation_state.travel("Turning")



func finished_turning():
	player_state = PlayerState.IDLE
	var desired_step: Vector2 = input_direction * TILE_SIZE / 1.94
	ray_cast.target_position = desired_step
	ray_cast.force_update_transform()


func get_directional_vector():
	var dir

	if player_facing_direction == FacingDirection.LEFT:
		# dir = FacingDirection.DOWN
		dir = directions["down"]
	elif player_facing_direction == FacingDirection.RIGHT:
		# dir = FacingDirection.UP
		dir = directions["up"]
	elif player_facing_direction == FacingDirection.DOWN:
		# dir = FacingDirection.LEFT
		dir = directions["right"]
	elif player_facing_direction == FacingDirection.UP:
		# dir = FacingDirection.UP
		dir = directions["left"]

	return dir


func move_by_direction(direction: String):
	var vec_dir

	match direction:
		"minus_90":
			vec_dir = get_directional_vector()
		_: 
			vec_dir = directions[direction]

	if input_direction.y == 0:
		input_direction.x += vec_dir.x
	if input_direction.x == 0:
		input_direction.y += vec_dir.y

	print(input_direction)
	if input_direction != Vector2.ZERO:
		animation_tree["parameters/Idle/blend_position"] = input_direction
		animation_tree["parameters/Walk/blend_position"] = input_direction
		animation_tree["parameters/Turning/blend_position"] = input_direction

		match direction:
			"minus_90": turn_player()
			"plus_90": turn_player()
			_: 
				initial_position = position
				is_moving = true
	else:
		animation_state.travel("Idle")
	# if input_direction != Vector2.ZERO:
	# 	# initial_position = position
	# 	# is_moving = true
	# 	travel_logic_update()


func travel_logic_update():
	if input_direction != Vector2.ZERO:
		animation_tree["parameters/Idle/blend_position"] = input_direction
		animation_tree["parameters/Walk/blend_position"] = input_direction
		animation_tree["parameters/Turning/blend_position"] = input_direction
		# animation_tree["parameters/Watering/blend_position"] = input_direction

		if is_need_to_turn():
			player_state = PlayerState.TURNING
			animation_state.travel("Turning")
		else:
			initial_position = position
			is_moving = true
	else:
		animation_state.travel("Idle")


func move(delta):
	if !ray_cast.is_colliding():
		percent_move_to_next_tile += wallk_speed * delta
		if percent_move_to_next_tile >= 1.0:
			position = initial_position + (TILE_SIZE * input_direction)
			percent_move_to_next_tile = 0.0
			is_moving = false
		else:
			position = initial_position + (TILE_SIZE * input_direction * percent_move_to_next_tile)
	else:
		is_moving = false
		percent_move_to_next_tile = 0.0
