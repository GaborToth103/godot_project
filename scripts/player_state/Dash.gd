class_name Dash extends State

func _init():
    gravity_enabled = false
    disabling_movement = true

func enter():
    super()
    animated_sprite_name = "Dash"
    # TODO set speed
    char_reference.velocity.x = char_reference.movement_data.dash_speed * sign(char_reference.velocity.x)

func exit():
    char_reference.velocity.x = 0

func update_physics(_delta: float):
    # TODO updating timer then return
    if char_reference.movement_data.dash_cooldown_timer > 0.0:
        char_reference.movement_data.dash_cooldown_timer -= _delta
    transition_in_seconds(0.1, "idle")

func update_animation(input_axis, animated_sprite_2d):
    if input_axis != 0:
        animated_sprite_2d.flip_h = (input_axis < 0)
    animated_sprite_2d.play(animated_sprite_name)
