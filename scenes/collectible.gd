extends Area2D

var collectible_group_string: String = "Collectibles" ## The group this node is part of

func _on_body_entered(_body:Node2D):
	queue_free()
	var collectibles = get_tree().get_nodes_in_group(collectible_group_string)
	if collectibles.size() == 1: # If this is the last collectible
		Events_name.level_completed.emit()
