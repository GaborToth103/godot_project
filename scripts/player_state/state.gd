class_name State extends Node

signal Transitioned

func enter():
    assert(false, "Entering this state is not implemented")

func exit():
    assert(false, "Exiting this state is not implemented")

func update(_delta: float):
    assert(false, "Updating this state is not implemented")

func update_physics(_delta: float):
    assert(false, "Updating this state's physics is not implemented")
