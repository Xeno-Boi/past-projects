extends "res://scripts/components/component.gd"


func _ready() -> void:
	model = defs.RamModel.r32
	super()	# parent


# info box manipulation

func updateInfoBox():
	if model:
		super.updateInfoBox()
		info_box_list.get_node("size/value").text = str(model.size)
		info_box_list.get_node("clockrate/value").text = str(model.clockrate)
		info_box_list.get_node("rating/value_bar").value = model.rating
		info_box_list.get_node("power_consumption/value").text = str(model.power_consumption)
