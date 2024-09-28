class_name WallSlide extends State

func _init():
    animated_sprite_name = "WallSlide"
    disabling_movement = true

func enter():
    super()
    char_reference.velocity.y = 0

func update_physics(_delta: float):
    if not char_reference.is_on_wall_only():
        char_reference.action_request = char_reference.RequestType.IDLE
        if char_reference.is_on_floor():
            Transitioned.emit(self, "idle")
        else:
            Transitioned.emit(self, "jump")
    elif char_reference.action_request == char_reference.RequestType.JUMP:
        char_reference.velocity.x = char_reference.get_wall_normal().x * char_reference.movement_data.speed
        char_reference.velocity.y = char_reference.movement_data.jump_velocity
        char_reference.just_wall_jumped = true
        Transitioned.emit(self, "jump")

func update_animation(input_axis, animated_sprite_2d):
    if input_axis != 0:
        animated_sprite_2d.flip_h = (input_axis < 0)
    animated_sprite_2d.play(animated_sprite_name)
