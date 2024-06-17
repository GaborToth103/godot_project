class_name FunnyFunction
static var player_scene: PackedScene = preload("res://scenes/CharacterS/player.tscn")

static func get_center_of_players(player_nodes: Array):
	if player_nodes.size() == 0:
		return null

	var total_position = Vector2(0, 0)
	for player in player_nodes:
		total_position += player.global_position

	return total_position / player_nodes.size()

static func get_furthest_distance_from_center(player_nodes: Array, center) -> float:
	var furthest_distance = 0.0
	if center:
		for player in player_nodes:
			var distance = player.global_position.distance_to(center)
			if distance > furthest_distance:
				furthest_distance = distance
	return furthest_distance

static func add_player(id: int = 1, target_node = null, cam_node = null):
	var player = player_scene.instantiate()
	player.name = str(id)
	print(player.name)
	if id != 1:
		cam_node.cam_index = id
	target_node.call_deferred("add_child", player)
