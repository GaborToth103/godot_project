class_name JumpEnd extends State

func enter():
    pass

func exit():
    pass

func update(_delta: float):
    pass

func update_physics(_delta: float):
    Transitioned.emit(self, "idle")
