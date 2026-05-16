extends StaticBody2D
class_name SelectableObject


'''
base class of any selectable objects
'''

# properties
@export var minigame = defs.MINIGAME.NONE	## minigame that loads when object is selected
@export var active : bool = true	## if the object is currently active
@export var has_minigame = false	## if the object has a minigame to load when selecting


# counters
var highlighting = false	## if the object is currently being selected by player


# child
@onready var indicator_arrow = $IndicatorArrow
@onready var sprite = $Sprite
@onready var cross = $Cross
@onready var cross_timer = $CrossTimer


# shader
@onready var sprite_shader_material = sprite.material


# signals
signal loadMinigame(minigame : int)


func _ready() -> void:
	if active:
		indicator_arrow.show()
	else:
		indicator_arrow.hide()
	cross.hide()


## selects object [br]
## if object contains a loadable minigame, loads minigame [br]
## if not, runs select action [br]
## does not check for active status
func select():
	if has_minigame:
		selectMinigameAction()
	else:
		selectAction()


## runs when being selected and has minigames [br]
## override in required class
func selectMinigameAction():
	emit_signal("loadMinigame", minigame)


## runs when being selected [br]
## override in required class
func selectAction():
	defs.attemptActivateTaskObjects(self)


## runs when being selected but is not active [br]
## override in required class
func selectNonActive():
	cross.show()
	cross_timer.start()


## activates selectable obejct [br]
## does not check for condition
func activate():
	active = true
	indicator_arrow.show()
	

## deactivates selectable obejct [br]
## does not check for condition
func deactivate():
	active = false
	indicator_arrow.hide()


## condition for the selectable to be activated [br]
## overwrite in needed class
func activateCondition() -> bool:
	return false


## condition for the selectable to be deactivated [br]
## overwrite in needed class
func deactivateCondition() -> bool:
	return false


## check for activate condition and activate accordingly [br]
## if object is active, check for deactivate condition and deactivate accordingly
func attemptActivate():
	if active:
		if deactivateCondition():
			deactivate()
	else:
		if activateCondition():
			activate()


## highlights object if being selected
func highlight(value : bool):
	highlighting = value
	sprite_shader_material.set_shader_parameter("highlight", value)


# signals

func _on_cross_timer_timeout() -> void:
	cross.hide()
