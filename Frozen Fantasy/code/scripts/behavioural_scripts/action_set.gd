extends Node
class_name ActionSet

"""
Behaviour for enemy and player units
"""

var defs = preload("res://defs.gd")

var alignment : bool = true
var parent : DynamicObj = null


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.



# BEHAVIOURAL FUNCTIONS
func parentClicked(rightClick: bool = false) -> void:
	#Delegates behaviour based on click
	
	pass



#HELPER FUNCTIONS

func setParent(newParent: DynamicObj) -> void:
	parent = newParent


func actionSetProcess() ->void:
	pass
