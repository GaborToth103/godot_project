class_name Jump extends State

var air_jump_combo: int = 0 ##  int signalling the iarjump count.

func _init():
	animated_sprite_name = "Jump"

func enter():
	super()
	air_jump_combo = 0

func update_physics(_delta: float):
	## Decide what action to do
	var ref = get_parent().target_character
	if ref.is_on_floor():
		if time_elapsed > 0.1:
			Transitioned.emit(self, "jump_end")
	elif ref.input_dict["jump"]:
		execute_jump()
	elif ref.RequestType.JUMP: # TODO use this instead but fix this because buggy
		return 
		execute_jump()

func update_animation(input_axis, animated_sprite_2d):
	if input_axis != 0:
		animated_sprite_2d.flip_h = (input_axis < 0)
	animated_sprite_2d.play(animated_sprite_name)

func handle_acceleration(input_axis, delta, x_vel, speed, _acc):
	char_reference.velocity.x = move_toward(x_vel, speed * input_axis, char_reference.movement_data.air_acceleration * delta)
	return char_reference.velocity.x

func execute_jump():
	if char_reference.is_on_wall_only():
		Transitioned.emit(self, "jump_start")
		return
	if char_reference.coyote_jump_timer.time_left > 0:
		char_reference.velocity.y = char_reference.movement_data.jump_velocity
	elif char_reference.velocity.y < char_reference.movement_data.jump_velocity / 2:
		char_reference.velocity.y = char_reference.movement_data.jump_velocity / 2
	elif air_jump_combo == 0 and not char_reference.just_wall_jumped: # double jump second phase
		char_reference.velocity.y = char_reference.movement_data.jump_velocity * 0.8
		air_jump_combo += 1
