extends SelectableObject
class_name ShelfObject

'''
base class of a shelf object
create inherited scene and add sprites to it
'''


# properties
#@export var shelf_sprite : Resource
@export var containing_item : bool = false


func _ready() -> void:
	super._ready()
	if containing_item:
		add_to_group("task_object")
		add_to_group("shelf_task")
		activate()
		has_minigame = true
		add_to_group("minigame_task")
	else:
		deactivate()


## runs when being selected and has minigames [br]
## override in required class
func selectMinigameAction():
	defs.current_minigame_shelf = self
	super.selectMinigameAction()


## runs when being selected [br]
## override in required class
func selectAction():
	defs.collectShelfItem(self)
	deactivate()
	super.selectAction()
