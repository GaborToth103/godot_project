class_name WallJump extends State

func enter():
	animated_sprite_name = "Jump"
	pass

func exit():
	pass

func update_physics(_delta: float):
	await wait(0.1)
	if get_parent().target_character.is_on_wall_only():
		Transitioned.emit(self, "WallSlide")
	if get_parent().target_character.is_on_floor():
		Transitioned.emit(self, "jump_end")

func update_animation(input_axis, animated_sprite_2d):
	if input_axis != 0:
		animated_sprite_2d.flip_h = (input_axis < 0)
	animated_sprite_2d.play(animated_sprite_name)