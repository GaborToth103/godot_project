class_name Idle extends State

var move_direction: Vector2
var wander_time: float

func enter():
	super()
	animated_sprite_name = "Idle"

func update_physics(_delta: float):
	var new_name = "idle"
	match char_reference.action_request:
		char_reference.RequestType.IDLE:
			if not char_reference.is_on_floor():
				Transitioned.emit(self, "jump")
			return
		char_reference.RequestType.JUMP:
			new_name = "jump_start"
		char_reference.RequestType.CROUCH:
			new_name = "crouch"
		char_reference.RequestType.DASH:
			new_name = "Dash"
	char_reference.action_request = char_reference.RequestType.IDLE
	Transitioned.emit(self, new_name)

func update_animation(input_axis, animated_sprite_2d):	
	if input_axis != 0:
		animated_sprite_2d.flip_h = (input_axis < 0)
		animated_sprite_2d.play("Move")
		return
	animated_sprite_2d.play(animated_sprite_name)

func handle_acceleration(input_axis, delta, x_vel, speed, acc):
	char_reference.velocity.x = move_toward(x_vel, speed * input_axis, acc * delta)
	return char_reference.velocity.x