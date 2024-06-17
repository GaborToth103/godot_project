class_name MyViewport
extends Control

@onready var view0: SubViewport = $HBoxContainer/Container0/Viewport
@onready var view1: SubViewport = $HBoxContainer/Container1/Viewport
@onready var cam0: Camera2D = $HBoxContainer/Container0/Viewport/Camera2D
@onready var cam1: Camera2D = $HBoxContainer/Container1/Viewport/Camera2D
@onready var world: World = $HBoxContainer/Container0/Viewport/World

@onready var hbox = $HBoxContainer
@onready var cont0 = $HBoxContainer/Container0
@onready var cont1 = $HBoxContainer/Container1

# TODO move child if players is in the reverse direction

var player_scene: PackedScene = preload("res://scenes/Characters/player.tscn")
@export var split_distance: float = 155

func resize_viewport(hide_secondary: bool):
	if hide_secondary:
		view0.size = Vector2(640, 360)
		view1.size = Vector2(0, 360)

		var player_nodes = get_tree().get_nodes_in_group("player")
		var center = FunnyFunction.get_center_of_players(player_nodes)
		if center:
			cam0.position = FunnyFunction.get_center_of_players(get_tree().get_nodes_in_group("player"))
	else:
		view0.size = Vector2(316, 360)
		view1.size = Vector2(316, 360)

func add_player(id: int = 1):
	var player = player_scene.instantiate()
	player.name = str(id)
	print(player.name)
	if id != 1:
		cam1.cam_index = id
	world.call_deferred("add_child", player)

func _ready():
	view1.world_2d = view0.world_2d

func _process(_delta):
	var player_nodes = get_tree().get_nodes_in_group("player")
	var center = FunnyFunction.get_center_of_players(player_nodes)
	var distance = FunnyFunction.get_furthest_distance_from_center(player_nodes, center)
	resize_viewport(distance < split_distance)

	for cam: ViewCam in get_tree().get_nodes_in_group("view_cam"):
		var target_player = cam.get_own_player()
		cam.set_cam_position(center, target_player, split_distance)
