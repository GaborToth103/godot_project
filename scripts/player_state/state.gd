class_name State extends Node

signal Transitioned
var char_reference: Player
var disabling_movement = false ## whether this state disabling movement or not
var animated_sprite_name: String = "state" ## this is the sprite name to animate
var time_elapsed: float
var waiting: bool = false
var gravity_enabled: bool = true

func enter():
	char_reference = get_parent().target_character
	time_elapsed = 0.0

func exit():
	pass

func update(delta: float):
	time_elapsed += delta

	apply_gravity(delta)
	apply_friction(delta)
	apply_air_resistance(delta)

	char_reference.action_request = char_reference.handle_input(char_reference.player_index)

	if not char_reference.pd.is_dead() and char_reference.control_enabled:
		char_reference.just_wall_jumped = false
		var was_on_floor = char_reference.is_on_floor()
		char_reference.move_and_slide()
		var just_left_ledge = was_on_floor and not char_reference.is_on_floor() and char_reference.velocity.y >= 0
		if just_left_ledge:
			char_reference.coyote_jump_timer.start()

	update_animation(char_reference.input_dict["axis"], char_reference.animated_sprite_2d)
	handle_acceleration(char_reference.input_dict["axis"], delta, char_reference.velocity.x, char_reference.movement_data.speed, char_reference.movement_data.acceleration)

func update_physics(_delta: float):
	pass

func update_animation(_input_axis, _animated_sprite_2d):
	pass

func handle_acceleration(_input_axis, _delta, _x_vel, _speed, _acc):
	return 0.0

func wait(seconds: float) -> void:
	if not waiting:
		waiting = true
		await get_tree().create_timer(seconds).timeout
		waiting = false

func transition_in_seconds(seconds_to_wait: float, target_state_name: String):
	if not waiting:
		waiting = true
		await get_tree().create_timer(seconds_to_wait).timeout
		Transitioned.emit(self, target_state_name)
		waiting = false

func apply_gravity(delta):
	if gravity_enabled:
		if not char_reference.is_on_floor():
			char_reference.velocity.y += char_reference.gravity * delta * char_reference.movement_data.gravity_scale

func apply_friction(delta):
	if char_reference.input_dict and char_reference.input_dict["axis"] == 0 and char_reference.is_on_floor():
		char_reference.velocity.x = move_toward(char_reference.velocity.x, 0, char_reference.movement_data.friction * delta)

func apply_air_resistance(delta):
	if char_reference.input_dict and char_reference.input_dict["axis"] == 0 and not char_reference.is_on_floor():
		char_reference.velocity.x = move_toward(char_reference.velocity.x, 0, char_reference.movement_data.air_resistance * delta)

## Executing jump function if this state allows
func execute_jump():
	assert(false, "Jump execution is not implemented in this state")
