extends "res://scripts/selectable_object.gd"


# child
var labelObject
var descriptionObject
var infoBox

# properties
@export var label = ""
@export var description = ""


func _ready() -> void:
	super()
	labelObject = $Label_panel/Label
	descriptionObject = $info_box/box_margin/Description
	infoBox = $info_box
	updateLable(label, description)
	infoBox.scale = Vector2(1.0 / scale.x, 1.0 / scale.y)
	infoBox.z_index = 1000
	infoBox.hide()
	


func updateLable(labelText, descriptionText):
	labelObject.text = labelText
	descriptionObject.text = descriptionText


# called when mouse is hovering above
func mouseHover():
	infoBox.show()


# called when mouse left
func mouseLeave():
	infoBox.hide()
