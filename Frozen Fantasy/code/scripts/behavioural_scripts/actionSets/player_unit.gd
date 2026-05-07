extends ActionSet
class_name PlayerUnit

"""
Functionality:
	highlight on click (set in group selected)
	Can target other units when they are clicked (will recieve a signal; set target param and do behaviour)
	Will use dynamic unit for move behaviour
	
"""




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.



# BEHAVIOURAL FUNCTIONS
func parentClicked(rightClick: bool = false) -> void:
	#Delegates behaviour based on click
	if rightClick:
		if defs.DEBUG_MODE:
			pass
			#parent.killUnit()
	else:
		if not Input.is_action_pressed("select_multiple"):	# clears multiple select when clicked
			defs.clearGroup(self, "selected")
		select()


func select():
	parent.add_to_group("selected")
	parent.selectedIndicator.visible = true


func actionSetProcess() -> void:
	
	if(parent.curState == DynamicObj.State.IDLE):
		
		if parent.actionTimer <= 0:
			parent.actionTimer = parent.targetScanInterval
			parent.findNewAttackTarget()
