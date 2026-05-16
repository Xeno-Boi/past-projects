extends SelectableObject


# states
enum MovementState {
	IDLE,
	MOVE
}

enum TaskState {
	FOLLOW,
	WANDERING
}

# child
@onready var nav_agent = $NavigationAgent
@onready var animation_tree = $AnimationTree
@onready var animation_state = animation_tree.get("parameters/playback")
@onready var select_hitbox = $SelectHitbox
@onready var wander_timer = $WanderTimer
@onready var wander_target_timer = $WanderTargetTimer


# reference
@export var player : Player


# properties
@export var speed : float = 5.0		## tiles per second
@export var sprint_multiplier : float = 3.0		## sprinting speed multiplier
@export var follow_distance : float = 100.0		## follow distance from player
@export var min_wander_time : float = 10.0	## minimum time for sibling to wander off
@export var max_wander_time : float = 120.0	## maximum time for sibling to wander off
@export var wander_target_change_chance : float = 30.0	## chance per 5 second that sibling will change target when wandering and idle, out of 100
@export var reachable_area : BoundingBox	## bounding box that contains the reachable area


# counters
var cur_movement_state : int = MovementState.MOVE
var cur_task_state : int = TaskState.FOLLOW
var sprinting : bool = false
var target_position : Vector2	# next target position


func _ready() -> void:
	randomize()
	speed *= defs.TILE_SIZE
	wander_target_change_chance /= 100.0
	deactivateWithoutAttemptActivate()
	super._ready()
	# set up timer
	wander_timer.wait_time = randf_range(min_wander_time, max_wander_time)
	wander_timer.start()


func _process(delta: float) -> void:
	match cur_task_state:
		TaskState.FOLLOW:
			target_position = player.position
		TaskState.WANDERING:
			pass


func _physics_process(delta: float) -> void:
	match cur_movement_state:
		MovementState.IDLE:
			if (global_position.distance_to(target_position) > follow_distance):
				cur_movement_state = MovementState.MOVE
				animation_state.travel("Run")
		MovementState.MOVE:
			if (global_position.distance_to(target_position) <= follow_distance):
				cur_movement_state = MovementState.IDLE
				animation_state.travel("Idle")
			else:
				nav_agent.target_position = target_position
				var next_path_position = nav_agent.get_next_path_position()
				var movement_dir = global_position.direction_to(next_path_position)
				animation_tree.set("parameters/Idle/blend_position", movement_dir)
				animation_tree.set("parameters/Run/blend_position", movement_dir)
				if sprinting:
					global_position += movement_dir * speed * sprint_multiplier * delta
				else:
					global_position += movement_dir * speed * delta


## runs when being selected [br]
## override in required class
func selectAction():
	deactivate()


## runs when being selected but is not active [br]
## override in required class
func selectNonActive():
	pass


## activates selectable obejct [br]
## does not check for condition
func activate():
	defs.uncompleteTask(defs.TASKS.SIBLING, self)
	cur_task_state = TaskState.WANDERING
	sprinting = true
	select_hitbox.monitorable = true
	wander_timer.stop()
	super.activate()
	
	# set target position
	setRandomTargetPosition()
	
	wander_target_timer.start()


## deactivates selectable obejct [br]
## does not check for condition
func deactivate():
	deactivateWithoutAttemptActivate()
	defs.attemptActivateTaskObjects(self)


## deactivate without trying to attempt to activate all task items [br]
## used in ready
func deactivateWithoutAttemptActivate():
	defs.completeTask(defs.TASKS.SIBLING, self)
	cur_task_state = TaskState.FOLLOW
	sprinting = false
	select_hitbox.monitorable = false
	wander_timer.start()
	super.deactivate()
	wander_target_timer.stop()


# helpers

## randomly generates a target position and set up the navigation agent
func setRandomTargetPosition():
	var target_x = randf_range(reachable_area.min_x, reachable_area.max_x)
	var target_y = randf_range(reachable_area.min_y, reachable_area.max_y)
	nav_agent.target_position = Vector2(target_x, target_y)
	target_position = nav_agent.get_final_position()


# signals

func _on_wander_timer_timeout() -> void:
	activate()


func _on_wander_target_timer_timeout() -> void:
	if randf() <= wander_target_change_chance:
		setRandomTargetPosition()
