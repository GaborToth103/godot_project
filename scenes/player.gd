#region Class Data
class_name Player
extends CharacterBody2D
#endregion

#region Properties
@export var player_index: int = 1 ## Player index for determining which player is which. 1 is default.
@export var movement_data: PlayerMovementData
@onready var animated_sprite_2d = $AnimatedSprite2D2
@onready var coyote_jump_timer = $CoyoteJumpTimer
@onready var startin_position = global_position

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var dash_time: float = 0.2  # Duration of the dash in seconds
var dash_speed: float = 500  # Speed during the dash
var dash_cooldown: float = 0.5  # Cooldown between dashes
var dash_timer: float = 0.0  # Timer to track the dash duration
var dash_cooldown_timer: float = 0.0  # Timer to track the cooldown
var just_wall_jumped: bool = false
var air_jump: bool = false
var is_dashing: bool = false
var control_enabled: bool = false

## Input dictionary of mostly bool values, input keys that are pressed
var input_dict: Dictionary = Dictionary()
#endregion

func _ready():
	position = Vector2(320, 180)

func _enter_tree():
	var id: int = name.to_int()
	set_multiplayer_authority(id)
	player_index = id
	control_enabled = is_multiplayer_authority() or player_index < 0

func handle_input(index) -> void:
	if index > 0: # non-local player detected, default controls set
		input_dict["dash"] = Input.is_action_just_pressed("dash2") or Input.is_joy_button_pressed(0, JOY_BUTTON_X)
		input_dict["jump"] = Input.is_action_just_pressed("jump2") or Input.is_joy_button_pressed(0, JOY_BUTTON_A)
		input_dict["crouch"] = Input.is_action_pressed("crouch2") or Input.is_joy_button_pressed(0, JOY_BUTTON_B)
		input_dict["axis"] = Input.get_axis("move_left2", "move_right2") + Input.get_joy_axis(0, JOY_AXIS_LEFT_X)
		input_dict["Attack"] = Input.is_action_pressed("attack") or Input.is_joy_button_pressed(0, JOY_BUTTON_X)
	else: # seocndary player's control on hotseat with primary player
		input_dict["dash"] = Input.is_action_just_pressed("dash") or Input.is_joy_button_pressed(1, JOY_BUTTON_X)
		input_dict["jump"] = Input.is_action_just_pressed("jump") or Input.is_joy_button_pressed(1, JOY_BUTTON_A)
		input_dict["crouch"] = Input.is_action_pressed("crouch") or Input.is_joy_button_pressed(1, JOY_BUTTON_B)
		input_dict["axis"] = Input.get_axis("move_left", "move_right") + Input.get_joy_axis(1, JOY_AXIS_LEFT_X)
		input_dict["Attack"] = Input.is_action_pressed("attack1") or Input.is_joy_button_pressed(1, JOY_BUTTON_X)
		
func _physics_process(delta):
	if not control_enabled: return
	handle_input(player_index)
	apply_gravity(delta)
	handle_dash(delta)
	handle_wall_jump()
	handle_jump()
	handle_acceleration(input_dict["axis"], delta)
	handle_air_acceleration(input_dict["axis"], delta)
	apply_friction(input_dict["axis"], delta)
	apply_air_resistance(input_dict["axis"], delta)
	update_animations(input_dict["axis"])
	just_wall_jumped = false
	var was_on_floor = is_on_floor()
	move_and_slide()
	var just_left_ledge = was_on_floor and not is_on_floor() and velocity.y >= 0
	if just_left_ledge:
		coyote_jump_timer.start()

func handle_dash(delta):
	if dash_cooldown_timer > 0.0:
		dash_cooldown_timer -= delta
	elif input_dict["dash"] and not is_dashing:
		is_dashing = true
		dash_timer = dash_time
		dash_cooldown_timer = dash_cooldown

	if is_dashing:
		dash_timer -= delta
		if dash_timer <= 0.0:
			is_dashing = false
		else:
			velocity.x = dash_speed * sign(velocity.x)

func apply_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * delta * movement_data.gravity_scale

func handle_wall_jump():
	if input_dict["jump"] and is_on_wall_only():
		velocity.x = get_wall_normal().x * movement_data.speed
		velocity.y = movement_data.jump_velocity
		just_wall_jumped = true

func handle_jump():
	if is_on_floor(): air_jump = true

	if is_on_floor() or coyote_jump_timer.time_left > 0.0:
		if input_dict["jump"]:	
			velocity.y = movement_data.jump_velocity
	elif not is_on_floor():
		if input_dict["jump"] and velocity.y < movement_data.jump_velocity / 2:	
			velocity.y = movement_data.jump_velocity / 2
		if input_dict["jump"] and air_jump and not just_wall_jumped: # double jump second phase
			velocity.y = movement_data.jump_velocity * 0.8
			air_jump = false

func apply_friction(input_axis, delta):
	if input_axis == 0 and is_on_floor():
		velocity.x = move_toward(velocity.x, 0, movement_data.friction * delta)

func apply_air_resistance(input_axis, delta):
	if input_axis == 0 and not is_on_floor():
		velocity.x = move_toward(velocity.x, 0, movement_data.air_resistance * delta)

func handle_acceleration(input_axis, delta):
	if is_on_floor() and input_axis:
		velocity.x = move_toward(velocity.x, movement_data.speed * input_axis, movement_data.acceleration * delta)

func handle_air_acceleration(input_axis, delta):
	if not is_on_floor() and input_axis:
		velocity.x = move_toward(velocity.x, movement_data.speed * input_axis, movement_data.air_acceleration * delta)


func update_animations(input_axis):
	if input_dict["dash"]:
			animated_sprite_2d.play("Dash")
			return
	if not is_on_floor():
			if input_dict["Attack"]:
				animated_sprite_2d.play("AttackJump")
			else:
				animated_sprite_2d.play("Jump")
	elif input_axis != 0:
		animated_sprite_2d.flip_h = (input_axis < 0)
		animated_sprite_2d.play("Move")
	elif input_dict["crouch"]:
		if input_dict["Attack"]:
			animated_sprite_2d.play("AttackCrouch")
		else:
			animated_sprite_2d.play("Crouch")
	elif input_dict["Attack"]:
		animated_sprite_2d.play("Attack")		
	else:
		animated_sprite_2d.play("Idle")

func _on_hazard_detector_area_entered(area:Area2D):
	global_position = startin_position
