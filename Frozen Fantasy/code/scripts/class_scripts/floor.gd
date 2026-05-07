extends Terrain3D


# callback function to when being clicked
func leftClickOn(click_position: Vector3):
	for node in get_tree().get_nodes_in_group("selected"):
		if node.has_method("followPath"):
			node.followPath(click_position)
