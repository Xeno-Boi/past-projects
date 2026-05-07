extends Node2D

onready var player = get_node("/root/Main/Stage/Player")

func _process(delta):
	self.global_position = player.position
