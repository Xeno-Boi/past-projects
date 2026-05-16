extends "res://scripts/components/component.gd"


func _ready() -> void:
	model = defs.HarddiskModel.H1TB
	super()	# parent


# info box manipulation

func updateInfoBox():
	if model:
		super.updateInfoBox()
		info_box_list.get_node("size/value").text = str(model.size)
		info_box_list.get_node("speed/value").text = str(model.speed)
		info_box_list.get_node("power_consumption/value").text = str(model.power_consumption)
