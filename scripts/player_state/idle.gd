class_name Idle extends State

var move_direction: Vector2
var wander_time: float

func randomize_wander():
	move_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	wander_time = randf_range(1, 3)

func enter():
	randomize_wander()

func exit():
	pass

func update(_delta: float):
	pass

func update_physics(_delta: float):
	if not get_parent().target_character.is_on_floor():
		print("transitioned")
		Transitioned.emit(self, "jump_start")
