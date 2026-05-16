extends Node2D

const defs = preload("res://scripts/defs.gd")

@export var scene_type: String = "workbench"

var selected_object = null
var dragging_component = false


# signal

signal turnInComputer(computer: Dictionary)


func _ready():
	# connect all selectable object signals
	for object in get_tree().get_nodes_in_group("selectable_objects"):
		object.mouseEntered.connect(onObjectMouseEnter)
		object.mouseExited.connect(onObjectMouseExit)
	# connect all component signals
	for component in get_tree().get_nodes_in_group("components"):
		component.startedDragging.connect(onComponentStartDraging)
		component.stoppedDragging.connect(onComponentStopDragging)
	
	trayInit()


# handles input
func input(event):
	# mouse click
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		# mouse click
		if event.pressed:
			if selected_object:	# has object selected
				selected_object.mouseClick()
		# mouse release
		else:
			if selected_object:	# has object selected
				selected_object.mouseRelease()
	
	if event is InputEventKey and event.pressed and event.keycode == KEY_SPACE:
		pass


# finds the top most object that the mouse is hovering on
func selectTopObject():
	var max_height = -INF
	var selected_object = null
	
	for object in get_tree().get_nodes_in_group("selectable_objects"):
		if object.mouse_entered:
			if object.accessible and object.height > max_height:	# component on top
				selected_object = object
				max_height = object.height
				
	return selected_object


# initialize all trays
func trayInit():
	# motherboard
	var motherboard_tray = $Component_shelf/MotherboardTray
	motherboard_tray.updateLable("Motherboard", defs.MotherboardModel.description)
	motherboard_tray.spawnComponent.connect(spawnComponent)
	for model in defs.MotherboardModel.models:
		var motherboard = defs.PRELOAD_SCENE[defs.TYPE.MOTHERBOARD].instantiate()
		motherboard.draggable = false
		motherboard.mouseEntered.connect(onObjectMouseEnter)
		motherboard.mouseExited.connect(onObjectMouseExit)
		motherboard_tray.addToShelf(motherboard)
		motherboard.updateModel(model)
	
	# cpu
	var cpu_tray = $Component_shelf/CpuTray
	cpu_tray.updateLable("Processor", defs.CpuModel.description)
	cpu_tray.spawnComponent.connect(spawnComponent)
	for model in defs.CpuModel.models:
		var cpu = defs.PRELOAD_SCENE[defs.TYPE.CPU].instantiate()
		cpu.draggable = false
		cpu.mouseEntered.connect(onObjectMouseEnter)
		cpu.mouseExited.connect(onObjectMouseExit)
		cpu_tray.addToShelf(cpu)
		cpu.updateModel(model)
	
	# gpu
	var gpu_tray = $Component_shelf/GpuTray
	gpu_tray.updateLable("Graphics", defs.GpuModel.description)
	gpu_tray.spawnComponent.connect(spawnComponent)
	for model in defs.GpuModel.models:
		var gpu = defs.PRELOAD_SCENE[defs.TYPE.GPU].instantiate()
		gpu.draggable = false
		gpu.mouseEntered.connect(onObjectMouseEnter)
		gpu.mouseExited.connect(onObjectMouseExit)
		gpu_tray.addToShelf(gpu)
		gpu.updateModel(model)
	
	# ram
	var ram_tray = $Component_shelf/RamTray
	ram_tray.updateLable("Ram", defs.RamModel.description)
	ram_tray.spawnComponent.connect(spawnComponent)
	for model in defs.RamModel.models:
		var ram = defs.PRELOAD_SCENE[defs.TYPE.RAM].instantiate()
		ram.draggable = false
		ram.mouseEntered.connect(onObjectMouseEnter)
		ram.mouseExited.connect(onObjectMouseExit)
		ram_tray.addToShelf(ram)
		ram.updateModel(model)

	# psu
	var psu_tray = $Component_shelf/PsuTray
	psu_tray.updateLable("Power Supply", defs.PsuModel.description)
	psu_tray.spawnComponent.connect(spawnComponent)
	for model in defs.PsuModel.models:
		var psu = defs.PRELOAD_SCENE[defs.TYPE.PSU].instantiate()
		psu.draggable = false
		psu.mouseEntered.connect(onObjectMouseEnter)
		psu.mouseExited.connect(onObjectMouseExit)
		psu_tray.addToShelf(psu)
		psu.updateModel(model)
	
	# harddisk
	var harddisk_tray = $Component_shelf/HarddiskTray
	harddisk_tray.updateLable("Harddisk", defs.HarddiskModel.description)
	harddisk_tray.spawnComponent.connect(spawnComponent)
	for model in defs.HarddiskModel.models:
		var harddisk = defs.PRELOAD_SCENE[defs.TYPE.HARDDISK].instantiate()
		harddisk.draggable = false
		harddisk.mouseEntered.connect(onObjectMouseEnter)
		harddisk.mouseExited.connect(onObjectMouseExit)
		harddisk_tray.addToShelf(harddisk)
		harddisk.updateModel(model)


# resets build
func resetBuild():
	# remove installed components
	for component in get_tree().get_nodes_in_group("components"):
		if component.occupying_slot:
			component.queue_free()
	# clear slots in case
	for slot in $ComponentGroup/Case.slots:
		slot.freeSlot()


# signals

# called when mouse enter any object
func onObjectMouseEnter():
	if not dragging_component:
		var object = selectTopObject()
		if object:	# object found
			if selected_object and selected_object != object:	# selected object changed from old to new
				selected_object.mouseLeave()
			selected_object = object
			selected_object.mouseHover()


# called when mouse exits any components
func onObjectMouseExit():
	if not dragging_component:
		var object = selectTopObject()
		if object:	# object found
			if selected_object and selected_object != object:	# selected object changed from old to new
				selected_object.mouseLeave()
			selected_object = object
			selected_object.mouseHover()
		else:	# object not found
			if selected_object:	# some object was selected
				selected_object.mouseLeave()
			selected_object = null


func onComponentStartDraging(component_type):
	dragging_component = true
	# highlight all available slots
	for slot in get_tree().get_nodes_in_group("slots"):
		if slot.type == component_type and slot.accessible:
			slot.turnOn()
	

func onComponentStopDragging(component):
	dragging_component = false
	# turn off all slots
	for slot in get_tree().get_nodes_in_group("slots"):
		slot.turnOff()
	
	# add component back to tray hold if tray hold is empty
	if not component.occupying_slot:	# component not installed
		var added_to_tray = false
		for tray in get_tree().get_nodes_in_group("component_tray"):
			if tray.type == component.type:	# correct tray
				if tray.isEmpty():	# hold is empty
					tray.holdComponent(component)
					added_to_tray = true
				elif tray.holding_component == component:	# already held by tray
					added_to_tray = true
				break
		if not added_to_tray:	# if trays are ocupied, delete item
			component.queue_free()


func spawnComponent(component):
	$ComponentGroup.add_child(component)
	component.mouseEntered.connect(onObjectMouseEnter)
	component.mouseExited.connect(onObjectMouseExit)
	component.startedDragging.connect(onComponentStartDraging)
	component.stoppedDragging.connect(onComponentStopDragging)


func _on_turn_in_result(success: bool):
	if success:
		resetBuild()
	else:
		$InformationScreen.turnOn($ComponentGroup/Case.getSpecs())
	

func _on_reset_button_pressed() -> void:
	resetBuild()


func _on_info_button_pressed() -> void:
	if not $InformationScreen.active :
		$InformationScreen.turnOn($ComponentGroup/Case.getSpecs())


func _on_turn_in_button_pressed() -> void:
	var computer = $ComponentGroup/Case.getSpecs()
	if defs.isValidComputer(computer):	# build is valid
		emit_signal("turnInComputer", computer)
	else:	# build is not valid
		$InformationScreen.turnOn($ComponentGroup/Case.getSpecs())
