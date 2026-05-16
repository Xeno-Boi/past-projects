extends PanelContainer

const defs = preload("res://scripts/defs.gd")

# child
var tween

# counters
var on_position : Vector2
var off_position : Vector2
var active = false


func _ready() -> void:	
	on_position = global_position
	off_position = Vector2(on_position.x + 1500, on_position.y)
	global_position = off_position


func turnOn():
	if not tween or not tween.is_valid():	# tween not created or finished moving
		tween = create_tween()
		tween.tween_property(self, "global_position", on_position, 0.3).set_ease(Tween.EASE_OUT)


func turnOff():
	tween = create_tween()
	tween.tween_property(self, "global_position", off_position, 0.3).set_ease(Tween.EASE_OUT)


# signal

func _on_close_button_pressed() -> void:
	turnOff()


func _on_open_task_board_button_pressed() -> void:
	turnOn()
