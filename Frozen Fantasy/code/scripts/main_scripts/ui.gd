extends Control

var defs = preload("res://defs.gd")
var label_theme = preload("res://scripts/label_theme.tres")

var wood_tag
var stone_tag
var fire_stone_tag
var new_fire_tag

var selecting_spawn = false
var selected_spawn_scene: PackedScene = null
# all spawnable buildings
@export var spawn_scenes: Dictionary = {
		"gatherer_campfire": preload("res://scenes/gatherer_campfire.tscn"),
		"warrior_hut": preload("res://scenes/warrior_hut.tscn"),
		"wizard_tower": preload("res://scenes/wizard_tower.tscn"),
		"pyre": preload("res://scenes/pyre.tscn"),
		"world_new_fire": preload("res://scenes/world_new_fire.tscn"),
	}

@onready var button_building_map = {
	$BottomPanel/BuildingListBG/BuildingList/GathererCampFireButton: "gatherer_campfire",
	$BottomPanel/BuildingListBG/BuildingList/WarriorsHutButton: "warrior_hut",
	$BottomPanel/BuildingListBG/BuildingList/WizardTowerButton: "wizard_tower",
	$BottomPanel/BuildingListBG/BuildingList/PyreButton: "pyre",
	$BottomPanel/BuildingListBG/BuildingList/WNFButton: "world_new_fire"
}

@onready var controls_hint_panel = $ControlsHint
@onready var tooltip_panel = $ResourceTooltipPanel
@onready var tooltip_label = $ResourceTooltipPanel/ResourceTooltipLabel
@onready var goal_list = $GoalList
@onready var toggle_controls_label = $ControlsHint/ControlsHintBG/ToggleControls
@onready var controls_container = $ControlsHint/ControlsHintBG/VBoxContainer
@onready var bottom_panel = $BottomPanel
@onready var event_panel = $BottomPanel/EventPanelBG
@onready var event_text_list = $BottomPanel/EventPanelBG/EventTextList

var show_controls = false
var resize_duration = 0.3

var debug_label

var main

# counters
@onready var unlocked_buildings = {
	$BottomPanel/BuildingListBG/BuildingList/GathererCampFireButton: false,
	$BottomPanel/BuildingListBG/BuildingList/WarriorsHutButton: false,
	$BottomPanel/BuildingListBG/BuildingList/WizardTowerButton: false,
	$BottomPanel/BuildingListBG/BuildingList/PyreButton: false,
	$BottomPanel/BuildingListBG/BuildingList/WNFButton: false
}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	wood_tag = $BottomPanel/ResourceList/Wood
	stone_tag = $BottomPanel/ResourceList/Stone
	fire_stone_tag = $BottomPanel/ResourceList2/FireStone
	new_fire_tag = $BottomPanel/ResourceList2/NewFire
	wood_tag.hide()
	stone_tag.hide()
	fire_stone_tag.hide()
	new_fire_tag.hide()
	
	debug_label = $DebugLabel
	
	main = get_tree().root.get_node("main")
	
	main.connect("resources_updated", Callable(self, "_on_resources_updated"))
	_on_resources_updated(main.resources)
	
	for button in button_building_map.keys():
		button.pressed.connect(_on_building_button_pressed.bind(button))
		button.mouse_entered.connect(_on_button_hover.bind(button))
		button.mouse_exited.connect(_on_button_exit)
		
	goal_list.connect("unlock_requested", Callable(self, "_unlock_building"))
	
	update_controls_visibility()

# temp function
func show_debug_label(debug_text: String):
	debug_label.text = debug_text
	await get_tree().create_timer(2).timeout
	debug_label.text = ""


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if tooltip_panel.visible:
		tooltip_panel.global_position = get_viewport().get_mouse_position() + Vector2(25, -50)


# input handling

func _input(event):
	if event.is_action_pressed("show_help"): # tab
		show_controls = !show_controls
		update_controls_visibility()

func leftClick(ray_result):
	if selecting_spawn:
		if ray_result:	# valid ray casting
			if ray_result.collider is Terrain3D:	# click on terrain
				var final_pos = ray_result.position + Vector3(0.0, 0.0, 0.0)
				
				var navigation = main.get_node("Terrain/NavigationRegion")
				var closest_nav_point = NavigationServer3D.map_get_closest_point(navigation.get_navigation_map(), final_pos)
				closest_nav_point.y = final_pos.y
				if closest_nav_point.distance_to(final_pos) > 0.5:
					show_debug_label("Invalid building position!")
					return
				
				var temp_building = selected_spawn_scene.instantiate()
				if temp_building is PlayerBuilding:
					temp_building.connect("building_placed", Callable(goal_list, "on_building_placed"))
					if not defs.DEBUG_MODE:
						for resource in temp_building.building_cost.keys():
							if main.resources.get(resource, 0) < temp_building.building_cost[resource]:
								show_debug_label("Not enough resources to build " + temp_building.name)
								temp_building.queue_free()
								return
				
				if not defs.DEBUG_MODE:
					if not "isPyreType" in temp_building and not defs.inPyreEffectiveArea(self, final_pos, true):
						show_debug_label(temp_building.name + " is not built near a Pyre!")
						return
				
				main.place_spawn_point(selected_spawn_scene, final_pos)
					
				show_debug_label("")
				deselectBuilding()
			elif ray_result.collider is DynamicObj and ray_result.collider.has_node("PlayerUnit"):	# clicked on player unit
				deselectBuilding()
			else:
				show_debug_label("Invalid building position!")
		else:
			show_debug_label("Invalid building position!")
			deselectBuilding()

# removes spawn selection
func rightClick():
	if selecting_spawn:
		show_debug_label("Cancel placing!")
	deselectBuilding()

func _on_building_button_pressed(button):
	var building_type = button_building_map[button]
	debug_label.text = "Selecting building: " + building_type
	selecting_spawn = true
	selected_spawn_scene = spawn_scenes[building_type]
	defs.clearGroup(self, "selected")

func _on_resources_updated(updated_resources):
	var wood_label = $BottomPanel/ResourceList/Wood/WoodAmount
	if updated_resources["wood"] == 0 :
		wood_tag.hide()
	else:
		wood_tag.show()
		wood_label.text = "[center]Wood: " + str(updated_resources["wood"]) + "[/center]"
	var stone_label = $BottomPanel/ResourceList/Stone/StoneAmount
	if updated_resources["stone"] == 0 :
		stone_tag.hide()
	else:
		stone_tag.show()
		stone_label.text = "[center]Stone: " + str(updated_resources["stone"]) + "[/center]"
	var fire_stone_label = $BottomPanel/ResourceList2/FireStone/FireStoneAmount
	if updated_resources["fire_stone"] == 0 :
		fire_stone_tag.hide()
	else:
		fire_stone_tag.show()
		fire_stone_label.text = "[center]Fire Stone: " + str(updated_resources["fire_stone"]) + "[/center]"
	var new_fire_label = $BottomPanel/ResourceList2/NewFire/NewFireAmount
	if updated_resources["new_fire_shard"] == 0 :
		new_fire_tag.hide()
	else:
		new_fire_tag.show()
		new_fire_label.text = "[center]Shard of New Fire: " + str(updated_resources["new_fire_shard"]) + "[/center]"

func _on_button_hover(button):
	var building_type = button_building_map[button]
	var temp_building = spawn_scenes[building_type].instantiate()
	
	if temp_building is PlayerBuilding:
		var cost_text = ""
		for resource in temp_building.building_cost.keys():
			var cost = temp_building.building_cost[resource]
			if cost == 0:
				continue
			cost_text += resource.capitalize() + " x" + str(cost) + "\n"
		
		tooltip_label.text = cost_text
		tooltip_panel.visible = true
		
		await get_tree().process_frame
		tooltip_panel.size = tooltip_label.size + Vector2(8.0, 1.5)

		temp_building.queue_free()

func _on_button_exit():
	tooltip_panel.visible = false
	
func _unlock_building(building_type: String):
	if !$BottomPanel/BuildingListBG.visible:
		$BottomPanel/BuildingListBG.show()
	for button in button_building_map.keys():
		if button_building_map[button] == building_type:
			button.show()
			unlocked_buildings[button] = true


func deselectBuilding():
	selecting_spawn = false
	selected_spawn_scene = null
	show_debug_label("")

func update_controls_visibility():
	controls_container.visible = show_controls
	toggle_controls_label.visible = true
	await get_tree().process_frame
	var target_size = get_controls_size() + Vector2(22, 17)
	
	var tween = create_tween()
	tween.tween_property(controls_hint_panel, "size", target_size, resize_duration)
	var target_label = toggle_controls_label if not show_controls else controls_container
	target_label.modulate.a = 0.0
	tween.tween_property(target_label, "modulate:a", 1.0, resize_duration)
	var hidden_label = controls_container if not show_controls else toggle_controls_label
	hidden_label.visible = false
	
func get_controls_size() -> Vector2:
	if show_controls:
		return controls_container.size
	else:
		return toggle_controls_label.size
		
func set_event_text_label(text: String, type = "info", max_lines = 2):
	var label = Label.new()
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.theme = label_theme
	label.text = text
	
	match type:
		"warning":
			label.add_theme_color_override("font_color", Color(0.9, 0.284, 0))  # orange
		"positive":
			label.add_theme_color_override("font_color", Color(0, 0.63, 0.107))  # green
		"weather":
			label.add_theme_color_override("font_color", Color(0, 0.533, 0.775))  # blue
		"danger":
			label.add_theme_color_override("font_color", Color(1, 0.1, 0.1))  # red
		_:
			label.add_theme_color_override("font_color", Color(0.322, 0.322, 0.322)) # gray
	
	event_text_list.add_child(label)
	await get_tree().process_frame
	resize_event_panel()
	event_panel.show()
	
	while event_text_list.get_child_count() > max_lines:
		event_text_list.get_child(0).queue_free()

func clear_event_text_labels():
	var to_remove = event_text_list.get_children()
	for l in to_remove:
		#print("Clearing event text!")
		l.queue_free()
	await get_tree().process_frame
	event_panel.hide()
	
func resize_event_panel():
	var panel_size = event_text_list.size + Vector2(40.0, 12.0)
	event_panel.size = panel_size
	event_panel.position = bottom_panel.size - panel_size - Vector2(25, 9)

# toggles visibility of debug toggle label
func toggleDebug(toggle : bool):
	$DebugToggle.visible = toggle
	$BottomPanel/BuildingListBG.visible = toggle
	for button in button_building_map.keys():
		if toggle:
			button.show()
		else:
			button.visible = unlocked_buildings[button]
