class_name FunnyFunction
extends Node

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
