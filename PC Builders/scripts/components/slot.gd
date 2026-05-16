extends StaticBody2D

const defs = preload("res://scripts/defs.gd")

# signals
signal slotOccupied
signal slotFreed

# properties
@export var type = defs.TYPE.DEFAULT

# counters
var occupied = null
var accessible = true

func _ready():
	modulate = Color(Color.CORNSILK)
	add_to_group("slots")
	turnOff()


# becomes visible, turns on collision
func turnOn():
	if not occupied:
		visible = true
		set_collision_layer_value(1, true)


# becomes invisible, turns off collision
func turnOff():
	visible = false
	set_collision_layer_value(1, false)


# occupy the slot
func useSlot(component):
	occupied = component
	emit_signal("slotOccupied")


# free the slot
func freeSlot():
	occupied = null
	emit_signal("slotFreed")
