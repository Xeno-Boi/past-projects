extends Node2D

'''
class for indicator arrows for tasks
'''


# child
@onready var arrow = $Arrow
@onready var animation_player = $Arrow/AnimationPlayer
@onready var starting_position = $StartingPosition


# reference
var indicator_bounding_box : IndicatorBoundingBox


# counters


func _ready() -> void:
	call_deferred("setUpIndicatorBoundingBox")


func setUpIndicatorBoundingBox():
	indicator_bounding_box = get_tree().root.get_node("Main/UI/IndicatorBoundingBox")
	
	
func _process(delta: float) -> void:
	if visible:
		var to_target : Vector2 = arrow.global_position - global_position
		arrow.global_rotation = atan2(to_target.y, to_target.x) + PI / 2
		var bound = indicator_bounding_box.getBoundingBox()
		if starting_position.global_position.x >= bound.min_x \
			and starting_position.global_position.x <= bound.max_x \
			and starting_position.global_position.y >= bound.min_y \
			and starting_position.global_position.y <= bound.max_y:	# arrow inside bounding box
				arrow.global_position = starting_position.global_position
				animation_player.play("FloatUpDown")
		else:	# arrow outside bounding box
			arrow.global_position.x = clamp(starting_position.global_position.x, bound.min_x, bound.max_x)
			arrow.global_position.y = clamp(starting_position.global_position.y, bound.min_y, bound.max_y)
			animation_player.play("static")
