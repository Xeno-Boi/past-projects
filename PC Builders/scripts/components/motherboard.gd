extends "res://scripts/components/component.gd"

# variables


func _ready() -> void:
	model = defs.MotherboardModel.high
	super()	# parent


# info box manipulation

func updateInfoBox():
	if model:
		super.updateInfoBox()
		info_box_list.get_node("rating/value_bar").value = model.rating
		info_box_list.get_node("power_consumption/value").text = str(model.power_consumption)


# signals

func onSlotOccupied():
	accessible = false


func onSlotFreed():
	if allSlotsFreed():
		accessible = true
