extends Node2D

'''
Main scene which controls the game
Holds different scenes and handles transition between scenes
e.g. title screen, world etc.
'''


# properties
@export var max_anxiety : int = 1000	## maximum anxiety level
@export var starting_anxiety : int = 0	## starting anxiety level
@export var starting_passive_anxiety_increase : int = 10	## starting amount for passive anxiety to increase
@export var passive_anxiety_increase_time : float = 5	## time needed for anxiety to increase passivly [br] in seconds


# counters
var current_screen : Node2D = null
var current_minigame : int = defs.MINIGAME.NONE


# child
var world : Node2D
var player : Node2D
@onready var ui = $UI
@onready var to_do_list = $UI/ToDoList
@onready var passive_anxiety_timer: Timer = $PassiveAnxietyTimer

# screens
var start_screen : Node2D
var end_screen : Node2D

## all existing screens
enum SCREEN_STATE{
	START_SCREEN,
	END_SCREEN,
	WORLD
}

## stores screen instances
@onready var SCREENS = {
	SCREEN_STATE.START_SCREEN : load("res://scenes/screens/start_screen.tscn").instantiate(),
	SCREEN_STATE.END_SCREEN : load("res://scenes/screens/end_screen.tscn").instantiate(),
	SCREEN_STATE.WORLD : null
}


func _ready() -> void:
	# connect signals
	SCREENS[SCREEN_STATE.START_SCREEN].startGame.connect(_on_start_game)
	SCREENS[SCREEN_STATE.END_SCREEN].restartGame.connect(_on_start_game)
	switchToScreen(SCREEN_STATE.START_SCREEN)
	

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("debug_button"):
		switchToScreen(SCREEN_STATE.END_SCREEN)
		
	if current_screen == world:	# world controls
			
		# if a minigame is loaded, close it
		# otherwise opens the breathing game
		if Input.is_action_just_pressed("breathing_game_button"):
			if get_tree().has_group("minigame"):
				if current_minigame == defs.MINIGAME.BREATHING_GAME:
					_onCloseBreathing()
			else:
				loadBreathingGame()
		
		if Input.is_action_just_pressed("close_minigame_button"):
			_onCloseBreathing()


func _process(delta: float) -> void:
	if current_screen != SCREENS[SCREEN_STATE.START_SCREEN] and \
		current_screen != SCREENS[SCREEN_STATE.END_SCREEN]:
		# in world or minigame
		if current_minigame != defs.MINIGAME.BREATHING_GAME:
			defs.updateBreathingGameTimer(delta)
			ui.updateBreathingIcon()


func _physics_process(delta: float) -> void:
	pass


# scene handling

## loads minigame to world and freezes world [br]
## only loads minigame if no minigame is currently running [br]
## takes def.MINIGAME enum [br]
## returns false if minigame is not loaded
func loadMinigame(minigame : int) -> bool:
	if get_tree().has_group("minigame"):	# there is a running minigame
		return false
	elif defs.MINIGAME_SCENE.has(minigame):	# input is a valid minigame
		# create instance of minigame
		var new_minigame = defs.MINIGAME_SCENE[minigame].instantiate()
		add_child(new_minigame)
		# initialize minigame
		#if "main" in new_minigame:
			#new_minigame.main = self
		new_minigame.add_to_group("minigame")
		match minigame:
			defs.MINIGAME.SELF_CHECKOUT_GAME:
				new_minigame.endOfGame.connect(_onEndOfGame)
				new_minigame.sendAnxietyChange.connect(_onSendAnxietyChange)
			defs.MINIGAME.BREATHING_GAME:
				new_minigame.restartAnxiety.connect(_onStartAnxiety)
				new_minigame.sendAnxietyChange.connect(_onSendAnxietyChange)
				new_minigame.closeBreathing.connect(_onCloseBreathing)
				_onPauseAnxiety()
			defs.MINIGAME.SHELF_GAME:
				new_minigame.endOfGame.connect(_onEndOfGame)
				new_minigame.sendAnxietyChange.connect(_onSendAnxietyChange)
		# pause world
		remove_child(world)		
		# update ui
		ui.to_do_list.hide()
		ui.toggleIcon(false)
		ui.hideBreathingWarning()
		current_minigame = minigame
		return true
	return false


## closes minigame and resumes world
func closeMinigame():
	# close all minigames (shousld only be one, just for safty)
	if get_tree().has_group("minigame"):
		for node in get_tree().get_nodes_in_group("minigame"):
			node.remove_from_group("minigame")
			node.queue_free()
	# resume world scene
	if world and not world.is_inside_tree():
		add_child(world)
	# update ui
	ui.to_do_list.show()
	ui.toggleIcon(true)
	ui.toggleBreathingWarning()
	current_minigame = defs.MINIGAME.NONE


# anxiety management

## updates current anxiety level, anxiety bar and passive anxiety increase
func updateAnxiety(anxiety_change):
	AnxietyCounter.current_anxiety += anxiety_change
	if AnxietyCounter.current_anxiety < 0:
		AnxietyCounter.current_anxiety = 0
	ui.toggleBreathingWarning()
	updatePassiveAnxietyIncrease()
	ui.updateAnxietyBarValue(AnxietyCounter.current_anxiety)

func updateAnxietyNoIncrease(anxiety_change):
	AnxietyCounter.current_anxiety += anxiety_change
	if AnxietyCounter.current_anxiety < 0:
		AnxietyCounter.current_anxiety = 0
	ui.toggleBreathingWarning()
	ui.updateAnxietyBarValue(AnxietyCounter.current_anxiety)

## updates passive anxiety increase based on current anxiety level exponentially
func updatePassiveAnxietyIncrease():
	# y = a + b * (1 - e^(c * (x + d)))
	var a = 4.0	# 1.92
	var b = - 0.01	# -0.098
	var c = 0.005	# 0.005
	var d = 400	# 400
	var increase_amount = a + b * (1 - exp(c * (AnxietyCounter.current_anxiety + d)))
	AnxietyCounter.passive_anxiety_increase += increase_amount


## switches to the provided screen [br]
## non active screens will not be updated
## does not reset screen!!
func switchToScreen(screen_state : int):
	assert(screen_state in SCREEN_STATE.values(), "switching to non existing screen state")
	if SCREENS[screen_state] == current_screen:	# no change
		return
	match screen_state:
		SCREEN_STATE.START_SCREEN:
			closeMinigame()
			passive_anxiety_timer.stop()
			ui.hide()
		SCREEN_STATE.END_SCREEN:
			closeMinigame()
			passive_anxiety_timer.stop()
			ui.hide()
		SCREEN_STATE.WORLD:
			passive_anxiety_timer.start()
			ui.show()
			ui.toggleIcon(true)
	# change scene
	if current_screen:	# not null
		remove_child(current_screen)
		current_screen = null
	current_screen = SCREENS[screen_state]
	add_child(current_screen)


## initialize / reset anxiety
func initializeAnxiety():
	# initialize variables
	AnxietyCounter.current_anxiety = starting_anxiety
	AnxietyCounter.passive_anxiety_increase = starting_passive_anxiety_increase
	
	# initialize anxiety bar
	ui.initializeAnxietyBar(max_anxiety, AnxietyCounter.current_anxiety)
	
	# start timer
	passive_anxiety_timer.wait_time = passive_anxiety_increase_time


## initialize world
func initializeWorld():
	# clear old world
	if SCREENS[SCREEN_STATE.WORLD]:
		SCREENS[SCREEN_STATE.WORLD].queue_free()
	# create world
	SCREENS[SCREEN_STATE.WORLD] = load("res://scenes/world.tscn").instantiate()
	switchToScreen(SCREEN_STATE.WORLD)
	
	world = SCREENS[SCREEN_STATE.WORLD]
	player = world.player
	
	# connect signals
	world.winGame.connect(_on_win_game)
	player.sendAnxietyChange.connect(_onSendAnxietyChange)
	for task in get_tree().get_nodes_in_group("minigame_task"):
		if task.has_signal("loadMinigame"):
			task.loadMinigame.connect(loadMinigame)
	
	# initialize to do list
	to_do_list.clearList()
	for task in defs.task_completion.keys():
		if not defs.task_completion[task]:
			to_do_list.addItem(task)
	
	to_do_list.showList()


## creates a new world and starts the game
func startGame():
	initializeWorld()
	initializeAnxiety()
	passive_anxiety_timer.start()


## checks for load condition and loads breathing game
func loadBreathingGame():
	#hide the breathing minigame instructions
	if not defs.breathingGameInCooldown():
		defs.resetBreathingGameTimer()
		ui.updateBreathingIcon()
		ui.toggleBreathingWarning()
		loadMinigame(defs.MINIGAME.BREATHING_GAME)

# signals

func _on_passive_anxiety_timer_timeout() -> void:
	updateAnxiety(AnxietyCounter.passive_anxiety_increase)
	
func _onEndOfGame(minigame : int):
	closeMinigame()
	match minigame:
		defs.MINIGAME.SELF_CHECKOUT_GAME:
			defs.completeTask(defs.TASKS.CHECKOUT, self)
		defs.MINIGAME.SHELF_GAME:
			if defs.current_minigame_shelf:
				defs.current_minigame_shelf.selectAction()
				defs.current_minigame_shelf = null
	defs.attemptActivateTaskObjects(self)

func _onSendAnxietyChange(anxiety: int):
	updateAnxietyNoIncrease(anxiety)
	
func _onPauseAnxiety():
	passive_anxiety_timer.paused = true

func _onStartAnxiety():
	passive_anxiety_timer.start()
	passive_anxiety_timer.paused = false
func _onCloseBreathing():
	_onStartAnxiety()
	closeMinigame()


func _on_win_game():
	switchToScreen(SCREEN_STATE.END_SCREEN)
	current_screen.setup(true)


func _on_lose_game():
	switchToScreen(SCREEN_STATE.END_SCREEN)
	current_screen.setup(false)


func _on_start_game():
	startGame()


func _on_anxiety_bar_full():
	_on_lose_game()
