class_name PlayerData
extends Node

@export var health = 100

func _refresh_health() -> void:
    if health < 0:
        health = 0
    elif health > 100:
        health = 100

func get_health() -> int:
    return health

func is_dead() -> bool:
    return health == 0

func increase_health(value: int) -> void:
    health += value
    _refresh_health()

func set_health(value: int) -> void:
    health = value
    _refresh_health()

