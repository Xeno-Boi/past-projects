extends "res://scripts/components/component.gd"


func _ready() -> void:
	model = defs.GpuModel.gtx1060
	super()	# parent


# info box manipulation

func updateInfoBox():
	if model:
		super.updateInfoBox()
		if model.raytracing:
			info_box_list.get_node("raytracing/value").text = "True"
		else:
			info_box_list.get_node("raytracing/value").text = "False"
		info_box_list.get_node("rating/value_bar").value = model.rating
		info_box_list.get_node("vram/value").text = str(model.vram)
		info_box_list.get_node("memory_type/value").text = model.memory_type
		info_box_list.get_node("power_consumption/value").text = str(model.power_consumption)
