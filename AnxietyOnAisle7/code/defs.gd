'''
Define file
Contains constants, helper functions that would be used accross all scenes
access defs like a class (defs.class_function())
all functions and variables here should be static (class attributes)
'''
class_name defs


## preloaded minigame scenes [br]
## key uses defs.MINIGAME enum
static var MINIGAME_SCENE = {
	MINIGAME.BREATHING_GAME: preload("res://scenes/minigames/breathing.tscn"),
	MINIGAME.SELF_CHECKOUT_GAME: preload("res://scenes/minigames/check-out.tscn"),
	MINIGAME.SHELF_GAME: preload("res://scenes/minigames/shelf-minigame.tscn")
}

## minigames enum [br]
## represents all minigames
enum MINIGAME{
	NONE,
	BREATHING_GAME,
	SELF_CHECKOUT_GAME,
	SHELF_GAME
}

## tasks enum [br]
## represents all tasks to be done
enum TASKS{
	CHECKOUT,
	SIBLING
}


## tasks completion dictionary [br]
## keeps track of task completion
static var task_completion = {}


## shelf item collection dictionary [br]
## keeps track of collection status of all shelf items
## key is the shelf object
static var shelf_item_collected = {}

# constants

## pixel size per tile
static var TILE_SIZE = 64
static var breathing_game_cooldown : float = 15.0	## in seconds


# helper functions

## attemps to activate all task objects
static func attemptActivateTaskObjects(target : Node):
	for object in target.get_tree().get_nodes_in_group("task_object"):
		object.attemptActivate()
	

## checks if all tasks are complete
static func allTaskComplete() -> bool:
	for task in task_completion.keys():
		if not task_completion[task]:
			return false
	return true
	

## sets completion status of a task to be true [br]
## pass in self as target
static func completeTask(task : int, target : Node):
	if task in task_completion.keys():
		task_completion[task] = true
		var to_do_list = target.get_tree().root.get_node("Main").to_do_list
		to_do_list.removeItem(task)
		to_do_list.showList()


## sets completion status of a task to be false
## pass in self as target
static func uncompleteTask(task : int, target : Node):
	if task in task_completion.keys():
		task_completion[task] = false
		var to_do_list = target.get_tree().root.get_node("Main").to_do_list
		to_do_list.addItem(task)
		to_do_list.showList()


## checks if a specific task is complete
static func taskIsCompleted(task : int) -> bool:
	if task in task_completion.keys():
		return task_completion[task]
	return false


## checks if all shelf items are collected
static func allShelfItemsCollected():
	for shelf in shelf_item_collected.keys():
		if not shelf_item_collected[shelf]:
			return false
	return true


## sets collection status of a shelf item to be true
static func collectShelfItem(shelf : ShelfObject):
	if shelf in shelf_item_collected.keys():
		shelf_item_collected[shelf] = true


## checks if sibling is missing
static func siblingIsMissing() -> bool:
	return not task_completion[TASKS.SIBLING]


## checks if breathgame is in cooldown
static func breathingGameInCooldown():
	return breathing_game_timer > 0.0
	

## updates breathing game timer
static func updateBreathingGameTimer(delta : float):
	if breathing_game_timer > 0.0:
		breathing_game_timer -= delta


## resets breathing game timer
static func resetBreathingGameTimer():
	breathing_game_timer = breathing_game_cooldown


# counters

static var current_minigame_shelf : ShelfObject = null	## keeps track of last shelf that opened shelf minigame
static var breathing_game_timer : float = 0.0
