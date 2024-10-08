class_name JumpEnd extends State

func enter():
    animated_sprite_name = "Jump"
    pass

func exit():
    pass

func update(_delta: float):
    pass

func update_physics(_delta: float):
    await wait(0.05)
    Transitioned.emit(self, "idle")

func update_animation(input_axis, animated_sprite_2d):
    if input_axis != 0:
        animated_sprite_2d.flip_h = (input_axis < 0)
    animated_sprite_2d.play(animated_sprite_name)
