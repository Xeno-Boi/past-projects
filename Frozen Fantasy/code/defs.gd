extends Node

'''
define file
contains constants, helper functions etc
preload into required files using var defs = preload("res://defs.gd)
'''

# variables

static var DEBUG_MODE : bool = false


# counters
static var timer_start_time : float = 0.0


# helper functions

## clears a specific group in tree of target, use self for target is enough
static func clearGroup(target : Node, group : String) -> void:
	for node in target.get_tree().get_nodes_in_group(group):
		node.remove_from_group(group)
		if(group == "selected"):
			if "selectedIndicator" in node:
				node.selectedIndicator.visible = false


## checks if a position is in the effective area of any pyre buildings
static func inPyreEffectiveArea(target : Node, position : Vector3, target_alignment : bool) -> bool:
	for pyre in target.get_tree().get_nodes_in_group("pyre_buildings"):
		if target_alignment == pyre.alignment:
			if pyre.has_method("isInArea"):
				if pyre.isInArea(position):
					return true
	return false


#safe multithreaded bake
static func safeNavBake(mainRef, nav_mesh : NavigationMesh):
	
	if mainRef.get_ref():
		mainRef.get_ref().bake_finished(nav_mesh)
	pass


# timer
static func start_timer():
	print("timer started")
	timer_start_time = Time.get_ticks_usec()

static func end_timer() -> float:
	var time_elasped = (Time.get_ticks_usec() - timer_start_time) / 1000
	print("timer ended")
	print("Time elasped: " + str(time_elasped) + " ms")
	return time_elasped
