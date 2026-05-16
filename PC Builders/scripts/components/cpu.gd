extends "res://scripts/components/component.gd"


func _ready() -> void:
	model = defs.CpuModel.i5
	super()	# parent


# info box manipulation

func updateInfoBox():
	if model:
		super.updateInfoBox()
		info_box_list.get_node("clockrate/value").text = str(model.clockrate)
		info_box_list.get_node("rating/value_bar").value = model.rating
		info_box_list.get_node("total_cores/value").text = str(model.total_cores)
		info_box_list.get_node("power_consumption/value").text = str(model.power_consumption)
		info_box_list.get_node("power_consumption_turbo/value").text = str(model.power_consumption_turbo)
