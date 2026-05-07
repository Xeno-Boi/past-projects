extends StaticBody2D

class_name MedicineBox

var signalType

onready var texture = $Texture

func _ready():
	texture.animation = "normal"
	texture.play()
	$Pickup.visible_characters = 0


func player_colliding(object):
	if object == self:
		texture.animation = "glowing"
		$Pickup.visible_characters = -1
		
func player_stop_colliding():
	texture.animation = "normal"
	$Pickup.visible_characters = 0
	
func player_interacting(object):
	if object == self:
		emit_signal(signalType)
