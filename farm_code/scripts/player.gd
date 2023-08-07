extends CharacterBody2D

class_name Player

@export var speed = 300.0
@export var wallk_speed = 2.0

# @onready var initial_position = Vector2.ZERO
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var animation_state = animation_tree["parameters/playback"]
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
	"plus_90": Vector2(0, 0),
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
	update_parameters()


func _physics_process(delta):
	match player_state:
		PlayerState.TURNING:
			pass
		PlayerState.WALKING:
			move(delta)
		PlayerState.IDLE:
			input_direction = Vector2.ZERO
			process_player_input()
		PlayerState.WATERING:
			pass

	# var desired_step: Vector2 = input_direction * TILE_SIZE / 1.94
	# ray_cast.target_position = desired_step
	# ray_cast.force_update_transform()

	# if player_state == PlayerState.TURNING:
	# 	return
	# elif not is_moving:
	# 	# input_direction = Vector2.ZERO
	# 	# travel_logic_update()
	# 	process_player_input()
	# elif input_direction != Vector2.ZERO:
	# 	animation_state.travel("Walk")
	# 	move(delta)
	# elif player_state == PlayerState.WATERING:
	# 	animation_state.travel("Watering")
	# else:
	# 	animation_state.travel("Idle")
	# 	is_moving = false


func process_player_input():
	if input_direction.y == 0:
		input_direction.x = (
			int(Input.is_action_pressed("right")) - int(Input.is_action_pressed("left"))
		)
	if input_direction.x == 0:
		input_direction.y = (
			int(Input.is_action_pressed("down")) - int(Input.is_action_pressed("up"))
		)

	if Input.is_action_just_pressed("watering"):
		player_state = PlayerState.WATERING

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
	# animation_state.travel("Turning")


func do_watering():
	player_state = PlayerState.WATERING


func finished_turning():
	player_state = PlayerState.IDLE
	var desired_step: Vector2 = input_direction * TILE_SIZE / 1.94
	ray_cast.target_position = desired_step
	ray_cast.force_update_transform()
	print("acabei de virar")


func finished_watering():
	player_state = PlayerState.IDLE
	# var desired_step: Vector2 = input_direction * TILE_SIZE / 1.94
	# print("acabou de regar")
	# input_direction = get_current_vector_position()
	# print(input_direction)
	# ray_cast.target_position = desired_step
	# ray_cast.force_update_transform()
	# input_direction = Vector2.ZERO


func get_minus90_directional_vector():
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


func get_plus90_directional_vector():
	var dir

	if player_facing_direction == FacingDirection.LEFT:
		dir = directions["up"]
	elif player_facing_direction == FacingDirection.RIGHT:
		dir = directions["down"]
	elif player_facing_direction == FacingDirection.DOWN:
		dir = directions["left"]
	elif player_facing_direction == FacingDirection.UP:
		dir = directions["right"]

	return dir


func get_current_vector_position():
	var dir

	if player_facing_direction == FacingDirection.LEFT:
		dir = directions["left"]
	elif player_facing_direction == FacingDirection.RIGHT:
		dir = directions["right"]
	elif player_facing_direction == FacingDirection.DOWN:
		dir = directions["down"]
	elif player_facing_direction == FacingDirection.UP:
		dir = directions["up"]

	return dir


func update_animation_tree():
	animation_tree["parameters/Idle/blend_position"] = input_direction
	animation_tree["parameters/Walk/blend_position"] = input_direction
	animation_tree["parameters/Turning/blend_position"] = input_direction
	animation_tree["parameters/Watering/blend_position"] = input_direction


func update_parameters():
	if input_direction != Vector2.ZERO:
		update_animation_tree()

	match player_state:
		PlayerState.WALKING:
			animation_tree["parameters/conditions/Walking"] = true
			animation_tree["parameters/conditions/Idle"] = false
			animation_tree["parameters/conditions/Turning"] = false
			animation_tree["parameters/conditions/Watering"] = false
		PlayerState.IDLE:
			animation_tree["parameters/conditions/Idle"] = true
			animation_tree["parameters/conditions/Walking"] = false
			animation_tree["parameters/conditions/Turning"] = false
			animation_tree["parameters/conditions/Watering"] = false
		PlayerState.TURNING:
			animation_tree["parameters/conditions/Turning"] = true
			animation_tree["parameters/conditions/Idle"] = false
			animation_tree["parameters/conditions/Walking"] = false
			animation_tree["parameters/conditions/Watering"] = false
		PlayerState.WATERING:
			animation_tree["parameters/conditions/Watering"] = true
			animation_tree["parameters/conditions/Idle"] = false
			animation_tree["parameters/conditions/Walking"] = false
			animation_tree["parameters/conditions/Turning"] = false

	# animation_tree["parameters/conditions/Turning"]
	# animation_tree["parameters/conditions/Walking"]
	# animation_tree["parameters/conditions/Watering"]


func move_by_direction(direction: String):
	var vec_dir

	match direction:
		"minus_90":
			vec_dir = get_minus90_directional_vector()
		"plus_90":
			vec_dir = get_plus90_directional_vector()
		"water":
			vec_dir = get_current_vector_position()
		_:
			vec_dir = directions[direction]

	if input_direction.y == 0:
		input_direction.x += vec_dir.x
	if input_direction.x == 0:
		input_direction.y += vec_dir.y

	print("posição -> " + direction)
	print(input_direction)
	if input_direction != Vector2.ZERO:
		update_animation_tree()

		match direction:
			"minus_90":
				turn_player()
			"plus_90":
				turn_player()
			"water":
				do_watering()
			_:
				initial_position = position
				is_moving = true
				player_state = PlayerState.WALKING
				# animation_state.travel("Walking")
	else:
		pass
		# animation_state.travel("Idle")


func travel_logic_update():
	if input_direction != Vector2.ZERO:
		animation_tree["parameters/Idle/blend_position"] = input_direction
		animation_tree["parameters/Walk/blend_position"] = input_direction
		animation_tree["parameters/Turning/blend_position"] = input_direction
		animation_tree["parameters/Watering/blend_position"] = input_direction

		if is_need_to_turn():
			player_state = PlayerState.TURNING
			# animation_state.travel("Turning")
		else:
			initial_position = position
			is_moving = true
			player_state = PlayerState.WALKING
	else:
		# animation_state.travel("Idle")
		pass


func move(delta):
	var desired_step: Vector2 = input_direction * TILE_SIZE / 1.94
	ray_cast.target_position = desired_step
	ray_cast.force_update_transform()

	if !ray_cast.is_colliding():
		percent_move_to_next_tile += wallk_speed * delta
		if percent_move_to_next_tile >= 1.0:
			position = initial_position + (TILE_SIZE * input_direction)
			percent_move_to_next_tile = 0.0
			is_moving = false
			player_state = PlayerState.IDLE
		else:
			position = initial_position + (TILE_SIZE * input_direction * percent_move_to_next_tile)
	else:
		is_moving = false
		player_state = PlayerState.IDLE
		percent_move_to_next_tile = 0.0


func interact_with_entity():
	if ray_cast.is_colliding():
		print(ray_cast.get_collider())
		var plant := ray_cast.get_collider()
		plant.emit_signal("watered")

	print("piece of crap")
