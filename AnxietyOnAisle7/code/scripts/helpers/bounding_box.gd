## an axis-aligned bounding box which contains values for its x and y values
extends Node
class_name BoundingBox

var min_x : float = 0.0
var max_x : float = 0.0
var min_y : float = 0.0
var max_y : float = 0.0

func _init(min_x : float, max_x : float, min_y : float, max_y : float) -> void:
	setBox(min_x, max_x, min_y, max_y)

## sets up the bounding box
## returns error if min is set larget than max, will not crash code
func setBox(min_x : float, max_x : float, min_y : float, max_y : float) -> int:
	if min_x > max_x \
		or min_y > max_y:
		push_error("Error, min value is larger than max value")
		return ERR_INVALID_PARAMETER
	self.min_x = min_x
	self.max_x = max_x
	self.min_y = min_y
	self.max_y = max_y
	return OK
