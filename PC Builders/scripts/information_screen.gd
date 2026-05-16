extends Control

const defs = preload("res://scripts/defs.gd")

# child
var tween

# list items
var overall_list
var motherboard_list
var cpu_list
var gpu1_list
var gpu2_list
var ram_list
var psu_list
var harddisk_list


# counters
var on_position : Vector2
var off_position : Vector2
var active = false
var mouse_entered_node = false	# mouse is in hitbox


func _ready() -> void:
	overall_list = $Info_scroll_list/Item_list/Overall
	motherboard_list = $Info_scroll_list/Item_list/Motherboard
	cpu_list = $Info_scroll_list/Item_list/Cpu
	gpu1_list = $Info_scroll_list/Item_list/Gpu1
	gpu2_list = $Info_scroll_list/Item_list/Gpu2
	ram_list = $Info_scroll_list/Item_list/Ram
	psu_list = $Info_scroll_list/Item_list/Psu
	harddisk_list = $Info_scroll_list/Item_list/Harddisk
	
	on_position = global_position
	off_position = Vector2(on_position.x + 1500, on_position.y)
	global_position = off_position


func _input(event):
	# mouse click
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		# mouse click
		if event.pressed:
			if active and not mouse_entered_node and not tween.is_valid():
				turnOff()


func turnOn(computer: Dictionary):
	if not tween or not tween.is_valid():	# tween not created or finished moving
		active = true
		updateList(computer)
		tween = create_tween()
		tween.tween_property(self, "global_position", on_position, 0.3).set_ease(Tween.EASE_OUT)


func turnOff():
	active = false
	tween = create_tween()
	tween.tween_property(self, "global_position", off_position, 0.3).set_ease(Tween.EASE_OUT)


func updateList(computer):
	var info
	# overall
	info = overall_list.get_node("Info")
	info.get_node("Price/Value").text = "$ " + str(defs.getCost(computer))
	info.get_node("Power_consumption/Value").text = str(defs.getPowerNeeded(computer)) + " W"
	if computer[defs.TYPE.PSU]:
		info.get_node("Power/Value").text = str(computer[defs.TYPE.PSU].power) + " W"
	else:
		info.get_node("Power/Value").text = "0 W"
	if defs.hasEnoughPower(computer):
		info.get_node("Power/Label").add_theme_color_override("font_color", Color(0, 1, 0))
		info.get_node("Power/Value").add_theme_color_override("font_color", Color(0, 1, 0))
	else:
		info.get_node("Power/Label").add_theme_color_override("font_color", Color(1, 0, 0))
		info.get_node("Power/Value").add_theme_color_override("font_color", Color(1, 0, 0))
	
	# motherboard
	var motherboard = computer[defs.TYPE.MOTHERBOARD]
	info = motherboard_list.get_node("Info")
	if not motherboard:	# motherboard not installed
		motherboard_list.get_node("Name_box/Name").add_theme_color_override("font_color", Color(1, 0, 0))
		motherboard_list.get_node("Name_box/Missing_label").show()
		info.hide()
	else:	# motherboard installed
		motherboard_list.get_node("Name_box/Name").add_theme_color_override("font_color", Color(0, 0, 0))
		motherboard_list.get_node("Name_box/Missing_label").hide()
		info.show()
		# update values
		info.get_node("Model/Value").text = motherboard.name
		info.get_node("Price/Value").text = "$ " + str(motherboard.price)
		info.get_node("Rating/value_bar").value = motherboard.rating
		info.get_node("Power_consumption/Value").text = str(motherboard.power_consumption)
	
	# cpu
	var cpu = computer[defs.TYPE.CPU]
	info = cpu_list.get_node("Info")
	if not cpu:	# cpu not installed
		cpu_list.get_node("Name_box/Name").add_theme_color_override("font_color", Color(1, 0, 0))
		cpu_list.get_node("Name_box/Missing_label").show()
		info.hide()
	else:	# cpu installed
		cpu_list.get_node("Name_box/Name").add_theme_color_override("font_color", Color(0, 0, 0))
		cpu_list.get_node("Name_box/Missing_label").hide()
		info.show()
		# update values
		info.get_node("Model/Value").text = cpu.name
		info.get_node("Price/Value").text = "$ " + str(cpu.price)
		info.get_node("Rating/value_bar").value = cpu.rating
		info.get_node("Total_core/Value").text = str(cpu.total_cores)
		info.get_node("Clockrate/Value").text = str(cpu.clockrate) + " GHz"
		info.get_node("Power_consumption/Value").text = str(cpu.power_consumption) + " W"
		info.get_node("Power_consumption_turbo/Value").text = str(cpu.power_consumption_turbo) + " W"
		
	# gpu
	var gpu = computer[defs.TYPE.GPU]
	if gpu == []:	# no gpu slots
		gpu1_list.hide()
		gpu2_list.hide()
	else:
		var gpu1 = gpu[0]
		var gpu2 = gpu[1]
		
		# gpu1
		if not gpu1:	# gpu1 not installed
			gpu1_list.hide()
		else:
			gpu1_list.show()
			# update values
			info = gpu1_list.get_node("Info")
			info.get_node("Model/Value").text = gpu1.name
			info.get_node("Price/Value").text = "$ " + str(gpu1.price)
			if gpu1.raytracing:
				info.get_node("Raytracing/Value").text = "True"
			else:
				info.get_node("Raytracing/Value").text = "False"
			info.get_node("VRam/Value").text = str(gpu1.vram) + " GB"
			info.get_node("Memory_type/Value").text = str(gpu1.memory_type)
			info.get_node("Power_consumption/Value").text = str(gpu1.power_consumption) + " W"
			info.get_node("Rating/value_bar").value = gpu1.rating
		
		# gpu2
		if not gpu2:	# gpu2 not installed
			gpu2_list.hide()
		else:
			gpu2_list.show()
			# update values
			info = gpu2_list.get_node("Info")
			info.get_node("Model/Value").text = gpu2.name
			info.get_node("Price/Value").text = "$ " + str(gpu2.price)
			if gpu2.raytracing:
				info.get_node("Raytracing/Value").text = "True"
			else:
				info.get_node("Raytracing/Value").text = "False"
			info.get_node("VRam/Value").text = str(gpu2.vram) + " GB"
			info.get_node("Memory_type/Value").text = str(gpu2.memory_type)
			info.get_node("Power_consumption/Value").text = str(gpu2.power_consumption) + " W"
			info.get_node("Rating/value_bar").value = gpu2.rating
	
	# ram
	var rams = computer[defs.TYPE.RAM]
	info = ram_list.get_node("Info")
	if rams == []:	# no ram slots
		ram_list.get_node("Name_box/Name").add_theme_color_override("font_color", Color(1, 0, 0))
		ram_list.get_node("Name_box/Missing_label").show()
		info.hide()
	else:
		var ram_count = 0
		var ram_price = 0
		var ram_size = 0
		var ram_power_consumption = 0
		var ram_rating = 0
		
		for ram in rams:	# calculated combined stats
			if ram:	# ram installed
				ram_count = ram_count + 1
				ram_price = ram_price + ram.price
				ram_size = ram_size + ram.size
				ram_power_consumption = ram_power_consumption + ram.power_consumption
				ram_rating = ram_rating + ram.rating
			
		if ram_count == 0:	# no ram installed
			ram_list.get_node("Name_box/Name").add_theme_color_override("font_color", Color(1, 0, 0))
			ram_list.get_node("Name_box/Missing_label").show()
			info.hide()
		else:	# at least one ram installed
			ram_list.get_node("Name_box/Name").add_theme_color_override("font_color", Color(0, 0, 0))
			ram_list.get_node("Name_box/Missing_label").hide()
			info.show()
			# update values
			info.get_node("Price/Value").text = "$ " + str(ram_price)
			info.get_node("Size/Value").text = str(ram_size) + " GB"
			info.get_node("Rating/value_bar").value = ram_rating / ram_count
			info.get_node("Power_consumption/Value").text = str(ram_power_consumption) + " W"
	
	# psu
	var psu = computer[defs.TYPE.PSU]
	info = psu_list.get_node("Info")
	if not psu:	# psu not installed
		psu_list.get_node("Name_box/Name").add_theme_color_override("font_color", Color(1, 0, 0))
		psu_list.get_node("Name_box/Missing_label").show()
		info.hide()
	else:	# psu installed
		psu_list.get_node("Name_box/Name").add_theme_color_override("font_color", Color(0, 0, 0))
		psu_list.get_node("Name_box/Missing_label").hide()
		info.show()
		# update values
		info.get_node("Model/Value").text = psu.name
		info.get_node("Price/Value").text = "$ " + str(psu.price)
		info.get_node("Power/Value").text = str(psu.power) + " W"
	
	# harddisk
	# ram
	var harddisks = computer[defs.TYPE.HARDDISK]
	info = harddisk_list.get_node("Info")
	if harddisks == []:	# no harddisk slots
		harddisk_list.get_node("Name_box/Name").add_theme_color_override("font_color", Color(1, 0, 0))
		harddisk_list.get_node("Name_box/Missing_label").show()
		info.hide()
	else:
		var harddisk_count = 0
		var harddisk_price = 0
		var harddisk_size = 0
		var harddisk_power_consumption = 0
		
		for harddisk in harddisks:	# calculated combined stats
			if harddisk:	# harddisk installed
				harddisk_count = harddisk_count + 1
				harddisk_price = harddisk_price + harddisk.price
				harddisk_size = harddisk_size + harddisk.size
				harddisk_power_consumption = harddisk_power_consumption + harddisk.power_consumption
			
		if harddisk_count == 0:	# no harddisk installed
			harddisk_list.get_node("Name_box/Name").add_theme_color_override("font_color", Color(1, 0, 0))
			harddisk_list.get_node("Name_box/Missing_label").show()
			info.hide()
		else:	# at least one ram installed
			harddisk_list.get_node("Name_box/Name").add_theme_color_override("font_color", Color(0, 0, 0))
			harddisk_list.get_node("Name_box/Missing_label").hide()
			info.show()
			# update values
			info.get_node("Price/Value").text = "$ " + str(harddisk_price)
			info.get_node("Size/Value").text = str(harddisk_size) + " TB"
			info.get_node("Power_consumption/Value").text = str(harddisk_power_consumption) + " W"
	
# signal

func _on_mouse_entered() -> void:
	mouse_entered_node = true


func _on_mouse_exited() -> void:
	mouse_entered_node = false
