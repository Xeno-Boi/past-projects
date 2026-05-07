extends Area2D

func not_colliding():
	return (self.get_overlapping_bodies().empty())
