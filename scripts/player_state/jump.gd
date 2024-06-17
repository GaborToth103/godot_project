class_name Jump extends State

func enter():
    pass

func exit():
    pass

func update(_delta: float):
    pass

func update_physics(_delta: float):
    if get_parent().target_character.is_on_floor():
        Transitioned.emit(self, "jump_end")
