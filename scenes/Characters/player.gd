class_name Player extends CharacterBody2D

#region Properties
@export var player_index: int = 1 ## Player index for determining which player is which. 1 is default.
@export var movement_data: PlayerMovementData
@onready var animated_sprite_2d = $AnimatedSprite2D2
@onready var coyote_jump_timer = $CoyoteJumpTimer
@onready var startin_position = global_position
@onready var pd: PlayerData = $PlayerData
@onready var movement_state: StateMachine = $MovementStateMachine

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var just_wall_jumped: bool = false
var air_jump: bool = false
var is_dashing: bool = false
var control_enabled: bool = false

## Input dictionary of mostly bool values, input keys that are pressed
var input_dict: Dictionary = {"axis" = 0}

enum RequestType {IDLE, JUMP, DASH, ATTACK, CROUCH, ATTACKCROUCH, ATTACKJUMP}
var action_request: RequestType = RequestType.IDLE
#endregion

func _ready():
	# Set Starting position
	position = Vector2(320, 180)

func _enter_tree():
	## Multiplayer data
	var id: int = name.to_int()
	set_multiplayer_authority(id)
	player_index = id
	control_enabled = is_multiplayer_authority() or player_index < 0

func handle_input(index) -> RequestType:
	## Returning requesting action and modifiying input dict
	if index > 0: # non-local player detected, default controls set
		input_dict["dash"] = Input.is_action_just_pressed("dash2") or Input.is_joy_button_pressed(0, JOY_BUTTON_X)
		input_dict["jump"] = Input.is_action_just_pressed("jump2") or Input.is_joy_button_pressed(0, JOY_BUTTON_A)
		input_dict["crouch"] = Input.is_action_pressed("crouch2") or Input.is_joy_button_pressed(0, JOY_BUTTON_B)
		input_dict["axis"] = Input.get_axis("move_left2", "move_right2") + Input.get_joy_axis(0, JOY_AXIS_LEFT_X)
		input_dict["Attack"] = Input.is_action_pressed("attack") or Input.is_joy_button_pressed(0, JOY_BUTTON_Y)
	else: # seocndary player's control on hotseat with primary player
		input_dict["dash"] = Input.is_action_just_pressed("dash") or Input.is_joy_button_pressed(1, JOY_BUTTON_X)
		input_dict["jump"] = Input.is_action_just_pressed("jump") or Input.is_joy_button_pressed(1, JOY_BUTTON_A)
		input_dict["crouch"] = Input.is_action_pressed("crouch") or Input.is_joy_button_pressed(1, JOY_BUTTON_B)
		input_dict["axis"] = Input.get_axis("move_left", "move_right") + Input.get_joy_axis(1, JOY_AXIS_LEFT_X)
		input_dict["Attack"] = Input.is_action_pressed("attack1") or Input.is_joy_button_pressed(1, JOY_BUTTON_Y)
	
	# to protect against controller degradation	and handle if both controller and keyboard are pressed.
	input_dict["axis"] = round(input_dict["axis"] * 10)/10
	if input_dict["axis"] >= 1:
		input_dict["axis"] = 1
	elif input_dict["axis"] <= -1:
		input_dict["axis"] = -1

	if input_dict["jump"]:
		return RequestType.JUMP
	elif input_dict["crouch"]:
		if input_dict["Attack"]:
			return RequestType.ATTACKCROUCH
		else:
			return RequestType.CROUCH
	elif input_dict["Attack"]:
		if not is_on_floor():
			return RequestType.ATTACKJUMP
		else:
			return RequestType.ATTACK
	elif input_dict["dash"]:
		return RequestType.DASH
	return RequestType.IDLE

func _process(_delta):
	pass 

func _physics_process(_delta):
	pass
	
#region TODO
func _on_hazard_detector_area_entered(_area:Area2D):
	# TODO hazard detection, now just teleports to the starting area 
	global_position = startin_position

func _on_hit_detector_area_entered(area:Area2D):
	var target = area.get_parent()
	if is_instance_of(target, Player):
		pd.increase_health(-1)
#endregion
