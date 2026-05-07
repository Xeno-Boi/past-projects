extends Node3D
class_name StaticObj

var defs = preload("res://defs.gd")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("static_objects")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if OS.is_debug_build(): print(name, " left clicked")
			for node in get_tree().get_nodes_in_group("selected"):
				if node.has_method("followPath"):
					node.followPath(event_position)
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			if OS.is_debug_build(): print(name, " right clicked")
	return
