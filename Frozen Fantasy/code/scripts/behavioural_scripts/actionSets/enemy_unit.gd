extends ActionSet
class_name EnemyUnit

"""
Functionality: 
	patrol behaviour, roam behaviour, etc.
	AI states for attacking, idle, maybe retreating, etc. 


"""



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	alignment = false
	pass # Replace with function body.


# BEHAVIOURAL FUNCTIONS
func parentClicked(rightClick: bool = false) -> void:
	#Delegates behaviour based on click
	select()
	pass


#sets all nodes in the group selected to try to target this unit
func select():
	for node in get_tree().get_nodes_in_group("selected"):
		if (node is DynamicObj):
			node.setAttackTarget(parent)

func actionSetProcess() -> void:
	
	if(parent.curState == DynamicObj.State.IDLE
	or parent.curState == DynamicObj.State.ROAM
	or parent.curState == DynamicObj.State.PATROL):
		
		if parent.actionTimer <= 0:
			parent.findNewAttackTarget()
			parent.actionTimer = parent.targetScanInterval
			
	
	pass
