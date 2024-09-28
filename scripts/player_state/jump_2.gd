class_name Jump2 extends State

func enter():
    animated_sprite_name = "Jump"
    pass

func exit():
    pass

func update(_delta: float):
    pass

func update_physics(_delta: float):
    assert(false)
    if get_parent().target_character.is_on_floor():
        Transitioned.emit(self, "jump_end")

func update_animation(input_axis, animated_sprite_2d):
    if input_axis != 0:
        animated_sprite_2d.flip_h = (input_axis < 0)
    animated_sprite_2d.play(animated_sprite_name)
