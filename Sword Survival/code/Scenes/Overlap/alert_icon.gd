extends AnimatedSprite

func _ready():
	hide()

func show():
	self.visible = true
	
func hide():
	self.visible = false
