class_name StateMachine extends Node

@export var target_character: Player
@export var move_speed: float = 10.0
@export var initial_state: State
var current_state: State
var states: Dictionary = {}

func _ready():
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.Transitioned.connect(on_child_transition)
	print(current_state)

	if initial_state:
		initial_state.enter()
		current_state = initial_state

func _process(delta: float):
	if current_state:
		current_state.update(delta)

func _physics_process(delta: float):
	print(current_state)
	if current_state:
		current_state.update_physics(delta)

func on_child_transition(state, new_state_name):
	if state != current_state:
		return

	var new_state = state.get(new_state_name.to_lower())
	if !new_state:
		print("wtf")
		return
	
	if current_state:
		current_state.exit()

	new_state.enter()
	current_state = new_state
