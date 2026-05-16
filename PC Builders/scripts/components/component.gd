extends "res://scripts/selectable_object.gd"

# base class for a component

# signals
signal startedDragging(component_type)
signal stoppedDragging(component)
signal componentClicked(component)

# child
var tween
var info_box
var info_box_list

# counters
var dragging = false	# being dragged
var initial_position : Vector2	# component position on the shelf
var target_slot = null	# component targeted slot on the workbench, 0 if not targeting any slots
var occupying_slot = null	# current occupying slot

# properties
@export var type = defs.TYPE.DEFAULT
var model = null
@export var slots: Array[StaticBody2D] = []
var size
var info_box_size


func _ready() -> void:
	super()	# parent
	# initialize children and variables
	info_box = $info_box
	info_box_size = info_box.scale
	info_box_list = $info_box/box_margin/items_list
	initial_position = global_position
	add_to_group("components")
	z_index = ceil(height)
	size = scale
	sizeDown()
	# initialize slots
	for slot in slots:
		slot.accessible = false
		slot.slotOccupied.connect(onSlotOccupied)
		slot.slotFreed.connect(onSlotFreed)
	disableAllSlots()
	# initialize info box
	updateInfoBox()
	info_box.hide()
	info_box.z_index = 1000


func _process(_delta: float) -> void:
	if dragging:	# being dragged
		position = get_global_mouse_position()


# mouse interaction
func mouseHover():	
	select()

func mouseLeave():
	deselect()

func mouseClick():
	if draggable:
		drag()
	emit_signal("componentClicked", self)

func mouseRelease():
	if draggable:
		release()


# highlight
func select():	
	sizeUp()
	z_index = 100
	info_box.show()

# remove highlight
func deselect():
	sizeDown()
	z_index = ceil(height)
	info_box.hide()


# called when component is being dragged
func drag():	
	switchToInstallModel()
	z_index = 100	# to be rendered on top of other components
	if occupying_slot:
		occupying_slot.freeSlot()
		occupying_slot = null
	dragging = true
	info_box.hide()
	emit_signal("startedDragging", type)


# called when component is being released
func release():
	z_index = ceil(height)
	dragging = false
	tween = create_tween()
	if not target_slot:	# not targeting any slots
		switchToDisplayModel()
		tween.tween_property(self, "global_position", initial_position, 0.1).set_ease(Tween.EASE_OUT)
		disableAllSlots()
	else:	# targeted a slot
		switchToInstallModel()
		target_slot.useSlot(self)
		occupying_slot = target_slot
		tween.tween_property(self, "global_position", target_slot.global_position, 0.1).set_ease(Tween.EASE_OUT)
		enableAllSlots()
	sizeUp()
	emit_signal("stoppedDragging", self)


func enableAllSlots():
	for slot in slots:
		slot.accessible = true
		

func disableAllSlots():
	for slot in slots:
		slot.accessible = false


func allSlotsFreed() -> bool:
	for slot in slots:
		if slot.occupied:
			return false
	return true


func sizeUp():
	if occupying_slot == null:
		if type == defs.TYPE.MOTHERBOARD:
			scale = size * 0.4
			info_box.scale = info_box_size / 0.4
		else:
			scale = size * 1.1
			info_box.scale = info_box_size / 1.1
	else:
		scale = size * 1.05
		info_box.scale = info_box_size / 1.05

func sizeDown():
	if occupying_slot == null:
		if type == defs.TYPE.MOTHERBOARD:
			scale = size * 0.3
			info_box.scale = info_box_size / 0.3
		else:
			scale = size
			info_box.scale = info_box_size
	else:
		scale = size
		info_box.scale = info_box_size


# returns specs
func getSpecs() -> Dictionary:
	var output = getSpecsStruct()
	for slot in slots:
		if slot.occupied:
			output = mergeComputerSpecs(output, slot.occupied.getSpecs())
		else:
			if output.has(slot.type):	# if slot type is valid
				if output[slot.type] is Array:	# add empty slot to array
					output[slot.type].append(null)
	# add self to output
	if output.has(type):	# if slot type is valid
		output[type] = model
	return output
	

# return specs structure
func getSpecsStruct() -> Dictionary:
	return defs.COMPUTER_STRUCT.duplicate(true)


# combines 2 computer struct dictionaries (adds input to target, not the other way around)
func mergeComputerSpecs(target: Dictionary, input: Dictionary) -> Dictionary:
	for key in target.keys():
		if target[key] is Array:
			if target[key] == []:
				if input[key] is Array:
					target[key] = input[key]
				else:
					target[key].append(input[key])
			else:
				if input[key] is Array:
					if input[key] != []:
						for i in range(target[key].size()):
							if target[key][i] == null:
								target[key][i] = input[key][i]
				else:
					target[key].append(input[key])
		else:
			if target[key] == null:
				target[key] = input[key]
	return target


func updateModel(model):
	assert(self.type == model.type, "Wrong Model Type")
	self.model = model
	switchToDisplayModel()
	updateInfoBox()


func switchToDisplayModel():
	$Sprite2D.texture = model.display_texture
	$hitbox/InstallCollisionShape.disabled = true
	$hitbox/DisplayColiisionShape.disabled = false


func switchToInstallModel():
	$Sprite2D.texture = model.install_texture
	$hitbox/InstallCollisionShape.disabled = false
	$hitbox/DisplayColiisionShape.disabled = true
		

# info box manipulation

func updateInfoBox():
	if model:
		info_box_list.get_node("model/value").text = model.name
		info_box_list.get_node("price/value").text = "$" + str(model.price)

# signals

func _on_hitbox_body_entered(body: Node2D) -> void:
	target_slot = body


func _on_hitbox_body_exited(body: Node2D) -> void:
	if target_slot == body:
		var overlapping_bodies = $hitbox.get_overlapping_bodies()
		if overlapping_bodies == []:
			target_slot = null
		else:
			target_slot = overlapping_bodies[0]


func onSlotOccupied():
	pass


func onSlotFreed():
	pass
