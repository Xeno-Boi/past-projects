extends StaticBody2D

class_name Bed

onready var texture = $Texture
var type = "light"
var rotate = 0
var patient = null

func _ready():
	texture.animation = "normal"
	texture.play()

func player_colliding(object):
	if object == self:
		texture.animation = "glowing"
	else:
		texture.animation = "normal"
		
func player_stop_colliding():
	texture.animation = "normal"

func player_interacting(object):
	if object == self:
		pass

func heal():
	if patient != null && !patient.healed:
		patient.heal()

