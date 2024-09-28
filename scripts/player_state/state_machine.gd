class_name StateMachine extends Node

@export var target_character: Player
@export var move_speed: float = 10.0
@export var initial_state: State
var current_state: State
var states: Dictionary = {}

# bálint polla team u18 player fiba ex3 2024 handball?
func get_disabled_movement():
	# TODO ask function: if function exists then it can be used
	return current_state.disabling_movement

func _ready():
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.Transitioned.connect(_on_child_transition)

	if initial_state:
		initial_state.enter()
		current_state = initial_state

func _process(delta: float):
	if current_state:
		current_state.update(delta)
		# print(current_state) # To print the current state use this

func _physics_process(delta: float):
	if current_state:
		current_state.update_physics(delta)

func _on_child_transition(state, new_state_name):
	if state != current_state:
		return

	var new_state = states.get(new_state_name.to_lower())
	if !new_state:
		assert(false, "State not found in the state machine scene tree")
		return
		
	if current_state:
		current_state.exit()

	new_state.enter()
	current_state = new_state
