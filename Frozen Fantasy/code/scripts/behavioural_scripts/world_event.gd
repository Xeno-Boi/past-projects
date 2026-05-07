extends Node



class WorldEvent extends Node3D:
	@onready var ui = get_tree().root.get_node("main/UI")
	var textualName = ""
	var warningDisplay = ""
	var startDisplay = ""
	var indefinite = false
	var abort = false
	var event_type = ""
	
	func _init() -> void:
		pass
	
	func prepareEvent() -> void:
		print(textualName)
		print(warningDisplay)
		
		ui.clear_event_text_labels()
		ui.set_event_text_label("= " + textualName + " = ", event_type)
		ui.set_event_text_label(warningDisplay, event_type)
		#any setup, figuring out who's effected, etc.
		pass
	
	func startEvent() -> void:
		print(startDisplay)
		
		ui.clear_event_text_labels()
		ui.set_event_text_label("= " + textualName + " = ", event_type)
		ui.set_event_text_label(startDisplay, event_type)
		#initiate the actual contents of the event
		pass
	
	func eventProcess(delta: float) -> void:
		#process function, but called directly for any event which needs a process
		pass
	
	func earlyEndCondition() -> bool:
		#for events that can end early
		ui.clear_event_text_labels()
		return false
	
	func cleanUpEvent() -> void:
		#cleanup, if any
		ui.clear_event_text_labels()
		pass


class PyreRaid extends WorldEvent:
	
	var targetPyre : BuildingObj
	var attackersSizeLimit : int = 7
	var attackers : Array = []
	
	func _init():
		textualName = "Pyre Raid"
		warningDisplay = "Enemies are gathering to try to assault one of your Pyres!"
		startDisplay = "Enemies are attacking!"
		event_type = "danger"
	
	func prepareEvent() ->void:
		super.prepareEvent()
		
		#find pyre, set it
		var pyres = get_tree().get_nodes_in_group("pyre_buildings")
		targetPyre = pyres[randi() % pyres.size()]
		

		
		#find attacking units, make way to rally point
		var units = get_tree().root.get_node("main").get_node("Units").get_children()
		for u in units:
			#might want a bit more to ensure we exclude bosses etc.
			if((u.alignment == false) and (u.boss == false) and (randi()%4 == 0)):
				attackers.append(u)
				var unitDir = (u.global_position - targetPyre.global_position).normalized()
				var rallyPoint = targetPyre.global_position + unitDir*10
				u.followPath(rallyPoint)
			if(attackers.size() == attackersSizeLimit):
				break
		pass
	
	
	func startEvent() -> void:
		super.startEvent()
		
		#if pyre has been destroyed, don't comman attack
		if not is_instance_valid(targetPyre):
			return
		
		for u in attackers:
			if is_instance_valid(u):
				u.setAttackTarget(targetPyre)
	
	func earlyEndCondition() -> bool:
		super.earlyEndCondition()
		
		for u in attackers:
			if is_instance_valid(u):
				return false
		return true



class Calm extends WorldEvent:
	
	func _init():
		textualName = "Calm Night"
		warningDisplay = "This night will be a calm one."
		startDisplay = "Night falls"
		event_type = "weather"



class EnemyReinforcements extends WorldEvent:
	
	func _init():
		textualName = "Enemy Reinforcements"
		warningDisplay = "Enemies are preparing to restock their units"
		startDisplay = "Enemy units get reinforcements!"
		event_type = "warning"
	
	func startEvent() ->void:
		super.startEvent()
		
		var spawner_exts = get_tree().get_nodes_in_group("spawner_building_extensions")
		for s in spawner_exts:
			if(s.get_parent() is EnemyBuilding):
				s.spawnChild()
				s.spawnChild()



class PlayerReinforcements extends WorldEvent:
	
	func _init():
		textualName = "Unit Reinforcements"
		warningDisplay = "Your units are feeling well. Prepare for more."
		startDisplay = "All your buildings spawn some units!"
		event_type = "positive"
	
	func startEvent() ->void:
		super.startEvent()
		
		var spawner_exts = get_tree().get_nodes_in_group("spawner_building_extensions")
		for s in spawner_exts:
			if(s.get_parent() is PlayerBuilding):
				s.spawnChild()
				s.spawnChild()



class ReplenishResources extends WorldEvent:
	
	func  _init():
		textualName = "Resource Deposits Replenish"
		warningDisplay = "Resource Deposits about to replenish"
		startDisplay = "Resources return to the land!"
		event_type = "positive"
	
	func startEvent():
		super.startEvent()
		
		var resources = get_tree().get_nodes_in_group("resource_deposits")
		for r in resources:
			r.replenish()
