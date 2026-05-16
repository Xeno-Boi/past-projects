extends Node2D

const defs = preload("res://scripts/defs.gd")

# base class for a component

# signals
signal mouseEntered
signal mouseExited

# counters
@export var accessible = true		# can be accessed
var mouse_entered = false	# mouse is in hitbox

# properties
@export var height : float = 0.0	# determines which object goes on top, larger = on top
@export var draggable : bool = false	# determines if the object can be dragged


func _ready() -> void:
	add_to_group("selectable_objects")
	z_index = ceil(height)


# called when mouse is hovering above
func mouseHover():	
	pass


# called when mouse left
func mouseLeave():
	pass


# called when object is being clicked
func mouseClick():	
	pass


# called when object is being released
func mouseRelease():
	pass
	
	
func updateHeight(value):
	height = value
	z_index = value


# signals

func _on_hitbox_mouse_entered() -> void:
	mouse_entered = true
	emit_signal("mouseEntered")


func _on_hitbox_mouse_exited() -> void:
	mouse_entered = false
	emit_signal("mouseExited")
