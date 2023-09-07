extends CharacterBody2D

class_name Player

signal sad_emoted

@export var speed = 300.0
@export var wallk_speed = 2.0

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var animation_state = animation_tree["parameters/playback"]
@onready var ray_cast: RayCast2D = $MoveRayCast2D
@onready var animated_sprite := $AnimatedSprite2D
@onready var sad_emote := $SadEmote

const TILE_SIZE = 16

enum PlayerState { IDLE, TURNING, WALKING, WATERING, AXING }
enum FacingDirection { LEFT, RIGHT, UP, DOWN }

var player_state := PlayerState.IDLE
var player_facing_direction := FacingDirection.DOWN

var input_direction = Vector2.ZERO
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

var prev_input_direction: Vector2


func _ready():
	animation_tree.active = true
	prev_input_direction = get_current_vector_position()
	sad_emoted.connect(run_sad_emote)

func update_select():
	if input_direction.x < 0:
		animated_sprite.position = Vector2(0, 16)
	elif input_direction.x > 0:
		animated_sprite.position = Vector2(32, 16)
	elif input_direction.y < 0:
		animated_sprite.position = Vector2(16, 0)
	elif input_direction.y > 0:
		animated_sprite.position = Vector2(16, 32)


func _process(_delta):
	update_parameters()
	update_select()


func update_ray_cast_to_player_direction():
	var desired_step: Vector2 = input_direction * TILE_SIZE / 1.94
	ray_cast.target_position = desired_step
	ray_cast.force_update_transform()


func _physics_process(delta):
	match player_state:
		PlayerState.TURNING:
			# turn_player()
			pass
		PlayerState.WALKING:
			move(delta)
		PlayerState.IDLE:
			input_direction = Vector2.ZERO
			# process_player_input()
		PlayerState.WATERING:
			pass
		PlayerState.AXING:
			pass

	update_ray_cast_to_player_direction()


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

	if Input.is_action_just_pressed("axing"):
		player_state = PlayerState.AXING

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


func run_sad_emote():
	sad_emote.visible = true
	await get_tree().create_timer(0.5).timeout
	sad_emote.visible = false
	sad_emoted.emit()


func turn_player():
	player_state = PlayerState.TURNING
	update_ray_cast_to_player_direction()


func do_watering():
	player_state = PlayerState.WATERING


func do_axing():
	player_state = PlayerState.AXING


func finished_turning():
	player_state = PlayerState.IDLE
	update_ray_cast_to_player_direction()


func finished_watering():
	player_state = PlayerState.IDLE


func finished_axing():
	player_state = PlayerState.IDLE


func get_minus90_directional_vector():
	var dir

	if prev_input_direction.x < 0:
		dir = directions["down"]
	elif prev_input_direction.x > 0:
		dir = directions["up"]
	elif prev_input_direction.y < 0:
		dir = directions["left"]
	elif prev_input_direction.y > 0:
		dir = directions["right"]
	else:
		dir = Vector2.ZERO

	return dir


func get_plus90_directional_vector():
	var dir

	if prev_input_direction.x < 0:
		dir = directions["up"]
	elif prev_input_direction.x > 0:
		dir = directions["down"]
	elif prev_input_direction.y < 0:
		dir = directions["right"]
	elif prev_input_direction.y > 0:
		dir = directions["left"]
	else:
		dir = Vector2.ZERO

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
	animation_tree["parameters/Axing/blend_position"] = input_direction


func update_parameters():
	if input_direction != Vector2.ZERO:
		update_animation_tree()

	match player_state:
		PlayerState.WALKING:
			animation_tree["parameters/conditions/Walking"] = true
			animation_tree["parameters/conditions/Idle"] = false
			animation_tree["parameters/conditions/Turning"] = false
			animation_tree["parameters/conditions/Watering"] = false
			animation_tree["parameters/conditions/Axing"] = false
		PlayerState.IDLE:
			animation_tree["parameters/conditions/Idle"] = true
			animation_tree["parameters/conditions/Walking"] = false
			animation_tree["parameters/conditions/Turning"] = false
			animation_tree["parameters/conditions/Watering"] = false
			animation_tree["parameters/conditions/Axing"] = false
		PlayerState.TURNING:
			animation_tree["parameters/conditions/Turning"] = true
			animation_tree["parameters/conditions/Idle"] = false
			animation_tree["parameters/conditions/Walking"] = false
			animation_tree["parameters/conditions/Watering"] = false
			animation_tree["parameters/conditions/Axing"] = false
		PlayerState.WATERING:
			animation_tree["parameters/conditions/Watering"] = true
			animation_tree["parameters/conditions/Idle"] = false
			animation_tree["parameters/conditions/Walking"] = false
			animation_tree["parameters/conditions/Turning"] = false
			animation_tree["parameters/conditions/Axing"] = false
		PlayerState.AXING:
			animation_tree["parameters/conditions/Axing"] = true
			animation_tree["parameters/conditions/Watering"] = false
			animation_tree["parameters/conditions/Idle"] = false
			animation_tree["parameters/conditions/Walking"] = false
			animation_tree["parameters/conditions/Turning"] = false


func move_by_direction(direction: String):
	var vec_dir

	match direction:
		"minus_90":
			vec_dir = get_minus90_directional_vector()
		"plus_90":
			vec_dir = get_plus90_directional_vector()
		"water":
			vec_dir = prev_input_direction
		"axing":
			vec_dir = prev_input_direction
		_:
			vec_dir = directions[direction]

	if input_direction.y == 0:
		input_direction.x += vec_dir.x
	if input_direction.x == 0:
		input_direction.y += vec_dir.y

	prev_input_direction = input_direction

	print("posição -> " + direction)
	print(input_direction)

	if input_direction != Vector2.ZERO:
		match direction:
			"minus_90":
				turn_player()
			"plus_90":
				turn_player()
			"water":
				do_watering()
			"axing":
				do_axing()
			_:
				initial_position = position
				player_state = PlayerState.WALKING


func travel_logic_update():
	if input_direction != Vector2.ZERO:
		animation_tree["parameters/Idle/blend_position"] = input_direction
		animation_tree["parameters/Walk/blend_position"] = input_direction
		animation_tree["parameters/Turning/blend_position"] = input_direction
		animation_tree["parameters/Watering/blend_position"] = input_direction
		animation_tree["parameters/Axing/blend_position"] = input_direction

		if is_need_to_turn():
			player_state = PlayerState.TURNING
		else:
			initial_position = position
			player_state = PlayerState.WALKING


func move(delta):
	update_ray_cast_to_player_direction()

	if !ray_cast.is_colliding():
		percent_move_to_next_tile += wallk_speed * delta
		if percent_move_to_next_tile >= 1.0:
			position = initial_position + (TILE_SIZE * input_direction)
			percent_move_to_next_tile = 0.0
			player_state = PlayerState.IDLE
		else:
			position = initial_position + (TILE_SIZE * input_direction * percent_move_to_next_tile)
	else:
		player_state = PlayerState.IDLE
		percent_move_to_next_tile = 0.0

	# percent_move_to_next_tile += wallk_speed * delta
	# if percent_move_to_next_tile >= 1.0:
	# 	position = initial_position + (TILE_SIZE * input_direction)
	# 	percent_move_to_next_tile = 0.0
	# 	player_state = PlayerState.IDLE
	# else:
	# 	position = initial_position + (TILE_SIZE * input_direction * percent_move_to_next_tile)



func interact_with_entity():
	if ray_cast.is_colliding():
		print(ray_cast.get_collider())
		var entity := ray_cast.get_collider()
		entity.emit_signal("interacted")
