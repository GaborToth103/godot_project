class_name ViewCam
extends Camera2D

@export var cam_index: int = 0
var remote_transform := RemoteTransform2D.new()
var transformed = false

func _ready():
	remote_transform.remote_path = get_path()

func set_cam_position(center, target_player, max_distance):
	if center and target_player:
		if not transformed:
			target_player.add_child(remote_transform)
			transformed = true
		if FunnyFunction.get_furthest_distance_from_center(get_tree().get_nodes_in_group("player"), center) > max_distance:
			global_position = target_player.position
		else:
			global_position = center

func get_own_player():
	for player: Player in get_tree().get_nodes_in_group("player"):
		if player.name.to_int() == cam_index:
			return player
