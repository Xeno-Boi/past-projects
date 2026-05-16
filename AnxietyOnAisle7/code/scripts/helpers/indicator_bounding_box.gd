extends ColorRect
class_name IndicatorBoundingBox

'''
class for indicator bounding box
bounds indicator arrows inside viewport
'''


# counters
var viewport_size : Vector2


func _ready() -> void:
	hide()
	viewport_size = Vector2(1280.0, 720.0)
	pass

func _process(delta: float) -> void:
	pass

## returns the bounding box of the indicator box
func getBoundingBox() -> BoundingBox:
	var world_pos = get_viewport().get_camera_2d().get_screen_center_position() - viewport_size / 2 + global_position
	var bounding_box : BoundingBox = BoundingBox.new(world_pos.x, world_pos.x + size.x, world_pos.y, world_pos.y + size.y)
	
	return bounding_box
