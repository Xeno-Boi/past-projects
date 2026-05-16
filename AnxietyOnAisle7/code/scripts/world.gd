extends Node2D

'''
Main world scene of the game
Should contain nodes for the store
'''


# property
var camera_bounding_box : BoundingBox


# child
@onready var player = $Objects/Player
@onready var sibling = $Objects/Sibling


# shader
@onready var radial_vingnette_shader = $ScreenSpaceEffects/RadialVignette


# signals
signal winGame()



func _ready() -> void:
	# initialize player
	# +-5 to account for border width
	camera_bounding_box = BoundingBox.new(roundi($Camera_Boundary/Left.position.x) + 5, roundi($Camera_Boundary/Right.position.x) - 5 ,roundi($Camera_Boundary/Top.position.y) + 5 ,roundi($Camera_Boundary/Bottom.position.y) - 5)
	player.setUpCamera(camera_bounding_box)
	
	# initialize task dictionary
	defs.task_completion = {}
	for i in defs.TASKS.values():
		defs.task_completion[i] = false
	defs.task_completion[defs.TASKS.SIBLING] = true
	
	# initialize shelf collected dictionary
	defs.shelf_item_collected = {}
	for shelf in get_tree().get_nodes_in_group("shelf_task"):
		defs.shelf_item_collected[shelf] = false
	
	# initialize sibling
	sibling.reachable_area = camera_bounding_box
	
	# initialize counters
	defs.breathing_game_timer = 0.0
	
	defs.attemptActivateTaskObjects(self)

func _input(event: InputEvent) -> void:
	pass


func _process(delta: float) -> void:
	# update shader params
	# radial vignette
	var shader_material = radial_vingnette_shader.material
	shader_material.set_shader_parameter("anxiety", AnxietyCounter.smooth_anxiety)


func _physics_process(delta: float) -> void:
	pass


# helper


# signals

func _on_win_game() -> void:
	emit_signal("winGame")
