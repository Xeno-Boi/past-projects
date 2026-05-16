extends "res://scripts/components/component.gd"

func _ready() -> void:
	super()	# parent
	accessible = false
	enableAllSlots()
	scale = Vector2(1.0, 1.0)
