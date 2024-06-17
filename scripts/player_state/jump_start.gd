class_name JumpStart extends State

func enter():
    print("jumpstart_started")

func exit():
    pass

func update(_delta: float):
    pass

func update_physics(_delta: float):
    Transitioned.emit(self, "jump")
