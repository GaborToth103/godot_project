class_name JumpStart extends State
var saved_speed: Vector2 = Vector2(0, 0)

func _init():
	animated_sprite_name = "jump_start"
	disabling_movement = true
	gravity_enabled = false

func enter():
	super()
	animated_sprite_name = "jump_start"
	if char_reference.is_on_wall_only(): 
		animated_sprite_name = "WallSlide"
	saved_speed = char_reference.velocity
	char_reference.velocity = Vector2(0, 0)

func exit():
	char_reference.velocity = saved_speed
	execute_jump()

func update_physics(_delta: float):
	transition_in_seconds(0.1, "jump")

func update_animation(input_axis, animated_sprite_2d):
	if input_axis != 0:
		animated_sprite_2d.flip_h = (input_axis < 0)
	animated_sprite_2d.play(animated_sprite_name)

func execute_jump():
	if char_reference.is_on_wall_only():
		char_reference.velocity.x = char_reference.get_wall_normal().x * char_reference.movement_data.speed
		char_reference.velocity.y = char_reference.movement_data.jump_velocity
		char_reference.just_wall_jumped = true
	else:
		char_reference.velocity.y = char_reference.movement_data.jump_velocity
