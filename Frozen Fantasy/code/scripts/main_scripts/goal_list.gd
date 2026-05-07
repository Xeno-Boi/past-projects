extends Control

@onready var vbox = $GoalListBG/VBoxContainer
@onready var panel = $GoalListBG

signal unlock_requested(type: String)

var main

var quests = [
	{
		"id": "collect_resources",
		"type": "resource_check",
		"title": "= Collect some resources =",
		"description": "Command your gatherers to gather resources.\nA resource point turns red means it's exhausted!",
		"goal": {
			"wood": 10,
			"stone": 10
		},
		"completed": false,
		"displayed": false,
		"reward": {
			"wood": 10,
			"stone": 10,
			"fire_stone": 1,
		},
		"unlock": "gatherer_campfire"
	},
	{
		"id": "build_gatherer_campfire",
		"type": "building_check",
		"title": "= Build a Gatherer Campfire =",
		"description": "A warmplace for 2 gatherers.\nBuildings must be placed WITHIN the power range of the Red Pyre!\nClick on the Pyre to check the area.",
		"progress": 0,
		"goal": 1,
		"completed": false,
		"displayed": false,
		"reward": {
			"wood": 20,
			"stone": 10,
			"fire_stone": 2,
		},
		"unlock": "warrior_hut"
	},
	{
		"id": "build_warrior_hut",
		"type": "building_check",
		"title": "= Build a Warrior Hut =",
		"description": "A camp for 3 warriors.\nWarriors are melee units, good at taking damage.\nUnits will keep respawning from their building as long as the Pyre is nearby!",
		"progress": 0,
		"goal": 1,
		"completed": false,
		"displayed": false,
		"reward": {
			"wood": 20,
			"stone": 10,
			"fire_stone": 2,
		},
		"unlock": "wizard_tower"
	},
	{
		"id": "build_wizard_tower",
		"type": "building_check",
		"title": "= Build a Wizard Tower =",
		"description": "A tower for 2 wizards\nWizards throw high damage magic ball from distance, but they have no armor.",
		"progress": 0,
		"goal": 1,
		"completed": false,
		"displayed": false,
		"reward": {
			"wood": 20,
			"stone": 10,
			"fire_stone": 2,
		},
	},
	{
		"id": "kill_enemy",
		"type": "enemy_check",
		"title": "= Kill Enemy =",
		"description": "Kill 10 enemy to get more resources!",
		"progress": 0,
		"goal": 10,
		"completed": false,
		"displayed": false,
		"reward": {
			"wood": 20,
			"stone": 10,
			"fire_stone": 5,
		},
	},
	{
		"id": "destroy_enemy_building",
		"type": "destroy_check",
		"title": "= Destroy Enemy Camp =",
		"description": "Destroy five enemy camp!",
		"progress": 0,
		"goal": 5,
		"completed": false,
		"displayed": false,
		"reward": {
			"wood": 30,
			"stone": 20,
			"fire_stone": 10,
		},
		"unlock": "pyre"
	},
	{
		"id": "build_pyre",
		"type": "building_check",
		"title": "= Build a Pyre =",
		"description": "This is the life source of your troops\nBuildings outside of a Pyre's range are not functional!",
		"progress": 0,
		"goal": 1,
		"completed": false,
		"displayed": false,
		"reward": {
			"wood": 30,
			"stone": 20,
			"fire_stone": 5
		},
		"unlock": "world_new_fire"
	},
	{
		"id": "build_world_new_fire",
		"type": "building_check",
		"title": "= The World's New Fire =",
		"description": "Build The World's New Fire to save the land from frozen!\nNew Fire Shards are scattered around the land, explore the world to find them!",
		"progress": 0,
		"goal": 1,
		"completed": false,
		"displayed": false
	},
	{
		"id": "kill_boss",
		"type": "enemy_check",
		"title": "= Slay the Frost Dragon =",
		"description": "Slay the dragon to get the final piece of New Fire Shard!\nThe Frost Dargon is guarding two New Fire Shard crystals at the middle of the land.",
		"progress": 0,
		"goal": 1,
		"completed": false,
		"displayed": false,
		"reward": {
			"wood": 20,
			"stone": 10,
			"fire_stone": 5,
			"new_fire_shard": 1
		},
	}
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	main = get_tree().root.get_node("main")
	main.connect("resources_updated", Callable(self, "_on_resources_updated_for_quests"))
	update_quest_list()
	# Connect kill signal for placed units
	var units_node = main.get_node("Units")
	for unit in units_node.get_children():
		unit.connect("killed", Callable(self, "on_unit_killed"))
		
	var buildings_node = main.get_node("Terrain/NavigationRegion/Buildings")
	for building in buildings_node.get_children():
		building.connect("destroyed", Callable(self, "on_building_destroyed"))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	await get_tree().process_frame
	panel.custom_minimum_size = vbox.get_size() + Vector2(25, 15)
	
func add_progress(quest_id: String, amount: int = 1):
	for quest in quests:
		if quest.id == quest_id and not quest.completed:
			quest.progress += amount
			if quest.progress >= quest.goal:
				mark_quest_completed(quest.id)
			else:
				update_quest_list()
			break

func on_building_placed(building_type: String):
	var building_quest_id = "build_" + building_type
	add_progress(building_quest_id)

func on_unit_killed(unit):
	if not unit.alignment:
		add_progress("kill_enemy")
		if unit.name.contains("Boss"):
			add_progress("kill_boss")
	else:
		# possible quest
		pass
	
func on_building_destroyed(building) -> void:
	if not building.alignment:
		print("Enemy building destroyed: ", building.name)
		add_progress("destroy_enemy_building")
	else:
		print("Player building destroyed: ", building.name)
		# possible quest

func update_quest_list():
	for child in vbox.get_children():
		child.queue_free()
		
	var shown_incomplete = 0
		
	for quest in quests:
		if quest.completed and not quest.displayed:
			var label = Label.new()
			label.text = "[Complete] " + quest.description
			vbox.add_child(label)
			quest.displayed = true
			var tween = create_tween()
			tween.tween_property(label, "modulate", Color.GOLD, 0.2)
			tween.tween_property(label, "modulate:a", 0.0, 2.0).set_delay(1.0)
			tween.tween_callback(Callable(label, "queue_free"))
		elif shown_incomplete < 2 and not quest.completed:
			var label = Label.new()
			var progress_text := ""
			if quest.has("type") and quest.type == "resource_check":
				for resource in quest.goal:
					var current = main.resources.get(resource, 0)
					var target = quest.goal[resource]
					progress_text += "\n    " + resource.capitalize() + ": " + str(current) + "/" + str(target)
					label.text = quest.title + "\n" + quest.description + progress_text
			else:
				progress_text = str(quest.progress) + "/" + str(quest.goal)
				label.text = quest.title + " [" + progress_text + "]" + "\n" + quest.description 
			vbox.add_child(label)
			shown_incomplete += 1

func mark_quest_completed(quest_id: String):
	for quest in quests:
		if quest.id == quest_id:
			quest.completed = true
			# giveout reward
			if quest.has("reward"):
				for resource in quest.reward:
					main.add_resource(resource, quest.reward[resource])
			if quest.has("unlock"):
				var unlock_type = quest.unlock
				emit_signal("unlock_requested", unlock_type)
	update_quest_list()

func check_resource_quests(resources: Dictionary) -> void:
	for quest in quests:
		if quest.type == "resource_check" and not quest.completed:
			var met = true
			for resource in quest.goal.keys():
				if resources.get(resource, 0) < quest.goal[resource]:
					update_quest_list()
					met = false
					break
			if met:
				mark_quest_completed(quest.id)

func _on_resources_updated_for_quests(updated_resources: Dictionary) -> void:
	check_resource_quests(updated_resources)

func connect_unit_signals(unit):
	if unit.has_signal("killed"):
		# Connect kill signal for spawn units
		unit.connect("killed", Callable(self, "on_unit_killed"))
