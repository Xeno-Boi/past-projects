extends Sprite

signal patient_dies

onready var animationPlayer = $AnimationPlayer

func _ready():
	animationPlayer.play("death_countdown")

func death_countdown_ends():
	emit_signal("patient_dies")

func end():
	animationPlayer.stop()
	self.visible = false
