extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func player_colliding(list):
	if (!list.empty() && list[0] == (self)):
		texture.animation = "glowing"
#		$Pickup.visible_characters = -1
	else:
		texture.animation = "normal"
#		$Pickup.visible_characters = 0
		
func player_stop_colliding():
	texture.animation = "normal"
#	$Pickup.visible_characters = 0
