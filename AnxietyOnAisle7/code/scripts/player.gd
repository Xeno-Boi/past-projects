extends CharacterBody2D
class_name Player

'''
Controls player related stuff
'''


# child
@onready var animation_tree = $AnimationTree
@onready var animation_state = animation_tree.get("parameters/playback")
@onready var camera = $Camera
@onready var npc_detector = $NpcDetector
@onready var npc_anxiety_timer = $NpcAnxietyTimer
@onready var sibling_anxety_timer = $SiblingAnxietyTimer
@onready var sprite = $Sprite

# properties
@export var speed : float = 5.0		## tiles per second
@export var sprint_multiplier : float = 1.7		## sprinting speed multiplier
@export var anxiety_increase_near_npc : float = 10.0	## per npc per second
@export var anxiety_increase_missing_sibling : float = 20.0		## per second

# counters
var input_vector : Vector2 = Vector2.ZERO
var sprinting : bool = false	## counter for sprinting state
var selecting_object : SelectableObject = null	## object player is currently selecting

# signals
signal sendAnxietyChange(anxiety : int)

func _ready() -> void:
	speed *= defs.TILE_SIZE
	npc_anxiety_timer.start()
	sibling_anxety_timer.start()
	

func _input(event: InputEvent) -> void:
	# player movement input
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vector.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	input_vector = input_vector.normalized()
	
	# set animation
	if input_vector != Vector2.ZERO:
		animation_tree.set("parameters/Idle/blend_position", input_vector)
		animation_tree.set("parameters/Run/blend_position", input_vector)
		animation_state.travel("Run")
	else:
		animation_state.travel("Idle")
	
	# sprint
	if Input.is_action_pressed("sprint"):
		sprinting = true
	else:
		sprinting = false
	
	# select
	if Input.is_action_just_pressed("select"):
		if selecting_object:	# selecting object exist
			#if selecting_object.minigame != defs.MINIGAME.NONE:		# object has minigame
			if (selecting_object.active):
				selecting_object.select()
			else:
				selecting_object.selectNonActive()
				emit_signal("sendAnxietyChange",100)


func _process(delta: float) -> void:
	pass


func _physics_process(delta: float) -> void:
	velocity = input_vector * speed
	if sprinting:
		velocity *= sprint_multiplier
	move_and_slide()


## updates the limit of the camera motion
func setUpCamera(bounding_box : BoundingBox):
	camera.limit_top = bounding_box.min_y
	camera.limit_bottom = bounding_box.max_y
	camera.limit_left = bounding_box.min_x
	camera.limit_right = bounding_box.max_x


# helpers

## finds closest object in player selectable detection area
## returns null if none
## only works with areas
func getClosestSelectableObject() -> SelectableObject:
	var closest_object : SelectableObject = null
	var min_distance : float = INF
	
	for area in $SelectHitBox.get_overlapping_areas():
		var object = area.get_parent()
		var new_distance = global_position.distance_to(object.global_position)
		if new_distance < min_distance:
			closest_object = object
			min_distance = new_distance
	
	return closest_object


# signals

func _on_select_hit_box_area_entered(area: Area2D) -> void:
	# select objects that enter detection area last
	if selecting_object:
		selecting_object.highlight(false)
	#selecting_object = area.get_parent()
	#selecting_object.highlight(true)
	
	# select closest object
	var closest_object = getClosestSelectableObject()
	selecting_object = closest_object
	selecting_object.highlight(true)


func _on_select_hit_box_area_exited(area: Area2D) -> void:
	if area.get_parent() == selecting_object:
		selecting_object.highlight(false)
	
	# select new closest object
	selecting_object = getClosestSelectableObject()
	if selecting_object:
		selecting_object.highlight(true)


func _on_npc_anxiety_timer_timeout() -> void:
	var anxiety_increase = anxiety_increase_near_npc * npc_detector.get_overlapping_bodies().size()
	emit_signal("sendAnxietyChange",anxiety_increase)


func _on_sibling_anxiety_timer_timeout() -> void:
	if defs.siblingIsMissing():
		emit_signal("sendAnxietyChange",anxiety_increase_missing_sibling)


func _on_npc_detector_body_entered(body: Node2D) -> void:
	var shader_material = sprite.material
	shader_material.set_shader_parameter("shaking", true)


func _on_npc_detector_body_exited(body: Node2D) -> void:
	var shader_material = sprite.material
	shader_material.set_shader_parameter("shaking", npc_detector.get_overlapping_bodies().size() > 0)
