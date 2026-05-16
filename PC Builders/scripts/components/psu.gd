extends "res://scripts/components/component.gd"


func _ready() -> void:
	model = defs.PsuModel.G750
	super()	# parent


# info box manipulation

func updateInfoBox():
	if model:
		super.updateInfoBox()
		info_box_list.get_node("power/value").text = str(model.power)
