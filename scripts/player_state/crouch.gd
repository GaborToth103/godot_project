class_name Crouch extends State

func enter():
	super()
	animated_sprite_name = "Crouch"

func update_physics(_delta: float):
	char_reference.velocity.x = 0.0
	if not char_reference.input_dict["crouch"]:
		char_reference.action_request = char_reference.RequestType.IDLE
		Transitioned.emit(self, "idle")

func update_animation(input_axis, animated_sprite_2d):
	if input_axis != 0:
		animated_sprite_2d.flip_h = (input_axis < 0)
	animated_sprite_2d.play(animated_sprite_name)
