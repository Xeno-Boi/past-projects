extends Node2D

const defs = preload("res://scripts/defs.gd")

# child
var component_shelf
var component_shelf_hitbox

# counters
var mouse_entered = false	# if mouse is in shelf
var holding_component = null	# component that tray is currently holding

# properties
@export var type = defs.TYPE.DEFAULT
@export var label = ""
@export var description = ""
@export var component_scale = 1.0
@export var accessible = true		# can be accessed
@export var height = 80.0

# signals
signal mouseEntered()
signal mouseExited()
signal spawnComponent(component)


func _ready() -> void:
	component_shelf = $Component_Shelf
	component_shelf.hide()
	component_shelf_hitbox = $Component_Shelf_Hitbox
	component_shelf_hitbox.hide()
	add_to_group("selectable_objects")
	add_to_group("component_tray")
	z_index = 0.0
	$Component_Shelf.z_index = height
	component_shelf_hitbox.get_node("shape").shape.extents = component_shelf.size / 2
	component_shelf_hitbox.position = Vector2(component_shelf.position.x + component_shelf.size.x / 2, component_shelf.position.y + component_shelf.size.y / 2)
	$ComponentName.updateLable(label, description)


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		# mouse click
		if event.pressed:
			if not mouse_entered:
				component_shelf.hide()
				component_shelf_hitbox.hide()


# called when mouse is hovering above
func mouseHover():	
	pass


# called when mouse left
func mouseLeave():
	pass


# called when object is being clicked
func mouseClick():	
	pass


# called when object is being released
func mouseRelease():
	pass


# checks if tray does not have any component spawned
func isEmpty():
	return holding_component == null


# adds component to hold of tray
func holdComponent(component):
	holding_component = component
	holding_component.stoppedDragging.connect(onComponentStoppedDragging)


# updates name and description of the selectable label
func updateLable(labelText, descriptionText):
	$ComponentName.updateLable(labelText, descriptionText)


# adds the component to the shelf and sets its properties accordingly
func addToShelf(component):
	var container = MarginContainer.new()
	container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	container.mouse_filter = Control.MOUSE_FILTER_IGNORE
	component.scale = component.scale * component_scale
	container.add_child(component)
	component.position = Vector2(80, 68)
	component.updateHeight(90)
	component.get_node("info_box").scale = component.get_node("info_box").scale / component_scale
	component_shelf.get_node("HShelf").add_child(container)
	component.componentClicked.connect(onComponentClicked)


# signals

func _on_shelf_button_pressed() -> void:
	if holding_component:
		holding_component.queue_free()
		holding_component = null
	component_shelf.show()
	component_shelf_hitbox.show()


func _on_component_shelf_hitbox_mouse_entered() -> void:
	mouse_entered = true
	emit_signal("mouseEntered")


func _on_component_shelf_hitbox_mouse_exited() -> void:
	mouse_entered = false
	emit_signal("mouseExited")


# signal
func onComponentClicked(component_selected):
	# spawns component
	var new_component = defs.PRELOAD_SCENE[type].instantiate()
	new_component.global_position = $Component_slot.global_position
	emit_signal("spawnComponent", new_component)
	new_component.updateModel(component_selected.model)
	holdComponent(new_component)
	
	# hides shelf
	component_shelf.hide()
	component_shelf_hitbox.hide()


func onComponentStoppedDragging(component):
	if holding_component.occupying_slot:	# component is installed
		holding_component.stoppedDragging.disconnect(onComponentStoppedDragging)
		holding_component = null
