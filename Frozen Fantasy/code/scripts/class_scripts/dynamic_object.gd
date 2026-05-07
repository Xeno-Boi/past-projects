extends CharacterBody3D
class_name DynamicObj

"""
Base class of dynamic objects (movable objects)

Present functionality:
	units easily customizable in scenes to have a series of unique attributes, different hitboxes, models, etc.
	Designed for ease of creation; making a full unit scene takes about 5 minutes (models and animation aside)
	Units have the following behaviour:
		a variety of different kinds of attacks can be added
		attacking at regular intervals, either on specific targets, or in areas
		Path following capabilits (adhere to terrain and follow 2D paths)
		Target following capabilities; switch to attack or gather when reached
		Switches attack targets when target dies; begins attacking attacker if idle and attacked
		Mouse controls -- select player units and click a target to make them act on that target.
		... and more!


TODO:
	Add behaviour for returning to a defined patrol once it has been broken
	Add behaviour for roaming (in enemy, probably)
	Add some randomness to attack damage (maybe)
	
	Add animations (later goal)

"""


enum State { #specify state with enum
	IDLE = 0, #does nothing -- may play animation
	MOVE_PATH = 1, #generic path following with no additional behaviour
	MOVE_DIRECTION = 2, # move in a specified direction
	FOLLOW = 3, #follow a unit directly. Simple, clean, etc. 
	ATTACK = 4, #periodic attacks on target or towards area
	GATHER = 5, #player only
	DEAD = 6, #niche, may go unused
	SPECIAL = 7, #niche, may go unused
	PATROL = 8, #for enemies. Similar to move, but may be used to ensure repeating path
	ROAM = 9, #for enemies. Random movement 
	# if state unknown, we can hangle with that with base case 
}


var curState : State = State.IDLE
var targetObject : Node3D = null #for targeting for attacks and mining. Quite important
var targetPosition : Vector3 = Vector3(0.0, 0.0, 0.0) # for targeting specific positions to move towards

@export var maxHealth : float = 1 #default amount should be changed in sublclasses
@onready var health : float = maxHealth
@export var mouseHitbox : Area3D = null # for mouse clicks
@export var visionArea: Area3D = null #for aggro and switching attacks once an enemy dies

@export var actions : ActionSet = null #for player of enemy actions
var alignment : bool = true

@export var boss : bool = false

@export var speed : float = 1.0 ##can be changed in subclasses for slow/fast units
var path : Curve2D = null ##for splines to move
var path_progress : float = 0 ## for spline pathing
var bearing: Vector3 = Vector3(0,0,0)	## look direction, always looking at movement direction
@export var gravity : float = 1.0

@export var attackType : AttackType = null ## null for no attack; class otherwise (type excluded for now until we have classes & subclasses defined)
@export var attackRate : float = 1.0 ##in attacks per second (irrelevant if no attacks)
@export var gatherRange : float = 2.5	## max distance to gather resource
@export var gatherRate : float = 1.0 ##in gather steps per second
@export var deathAnimationLength : float = 3 # in seconds
@export var stopLimit : float = 1.0	## in seconds, time needed for unit to switch to IDLE if not moving
@export var pathfindInteral : float = 1.0	## in seconds, interval between path finding
@export var targetScanInterval : float = 1.0	## in seconds, interval between scanning for targets
@export var patrol : bool = false	## patrol mode toggle
@export var patrol_path : Array[PatrolNode] = []	## list of nodes the unit will patrol on
@export var random_path : bool = true	## if the unit follows nodes in the path in order

@onready var navigationAgent = $NavigationAgent
@onready var healthBar = $OverheadDisplay/SubViewport/HealthBar
@onready var selectedIndicator = $OverheadDisplay/SubViewport/SelectedIndicator


var actionTimer : float = -1 #time till next action (attack, gather, etc.)
var stopTimer : float = 0.0	# time the unit stopped for

var parentBuilding : SpawnerBuilding = null #can notify parent building of death etc.

signal killed(unit)


# counter
var current_patrol_node : PatrolNode = null	## current target node
var last_patrol_node : PatrolNode = null	## last target node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:

	# make sure action set and attack type is properly set up
	assert(actions, "no action set")
	assert(attackType, "no attack type")

	actions.setParent(self)
	alignment = actions.alignment
	
	add_to_group("units")
	
	randomize()
	
	if patrol:
		findNextPatrolPath(false)
		changeState(State.PATROL)


#UNIT CORE STATE MODIFICATION FUNCTIONS

func setParent(parent : SpawnerBuilding) ->void:
	parentBuilding = parent


func changeActionSet(newSet: ActionSet) ->void:
	#Call while instantiating a new ActionSet
	
	alignment = newSet.alignment
	actions.queue_free()
	add_child(newSet)
	actions = newSet


func killUnit() ->void:
	# first half of killing unit -- plays death animation and sets state to dead
	curState = State.DEAD
	actionTimer = deathAnimationLength 
	emit_signal("killed", self) #signal that it died, to all concerned parties

	#ADD TRIGGERING DEATH ANIMATION HERE (if any)
	
	
	if OS.is_debug_build(): print(name, " was killed")
	get_viewport().get_camera_3d().stop_tracking_if_killed(self)
	
	pass


func despawnUnit() ->void:
	queue_free()
	#any behaviour after it exits scene? Or before?



#ACTION FUNCTIONS

func takeDamage (damageVal : float, attacker : DynamicObj = null) ->void:
	if(curState == State.DEAD): return
	
	health -= damageVal
	healthBar.value = (health/maxHealth)*100
	
	if(health <= 0):
		killUnit()
		return
	
	if (curState == State.IDLE or curState == State.PATROL or curState == State.ROAM):
		#when hit by attacker, attack in return if idle
		setAttackTarget(attacker)
	#PASS SOME PARAM TO SHADER TO INDICATE DAMAGE


func setAttackTarget (newTarget) -> void:
	#newTarget can be a building or a DynamicObj
	if(newTarget is DynamicObj or newTarget is BuildingObj):
		targetObject = newTarget
		updatePath(targetObject.global_position)
		# TODO: change to raycasting to prevent hitting through walls
		if(attackType.attackRange < (targetObject.global_position - global_position).length()):
			changeState(State.FOLLOW)
		else:
			changeState(State.ATTACK)


func setGatherTarget (newTarget) -> void:
	if(not newTarget is ResourceDep): return
	targetObject = newTarget
	#need to be within gather range
	if(gatherRange < (targetObject.global_position - global_position).length()):
		changeState(State.FOLLOW)
	else:
		changeState(State.GATHER)


func attack() -> void:
	#behaviour varies based on passed in attack class
	attackType.attack(self)
	
	if (targetObject is DynamicObj and targetObject.curState == State.DEAD):
		findNewAttackTarget()
	
	#PLAY ATTACK ANIMATIONS HERE IF ANY
	pass


func gather() -> void:
	#gathers resource from Target. Includes error handling.
	if(not targetObject is ResourceDep):
		return
	
	targetObject.take_resource()
	
	if(targetObject.getExhausted()):
		changeState(State.IDLE)
	
	pass


## updates target position of the navigationAgent
func updatePath(newTargetPosition: Vector3):
	targetPosition = newTargetPosition
	navigationAgent.target_position = targetPosition


## sets target position of object and tells it to follow path
func followPath(newTargetPosition:Vector3):
	updatePath(newTargetPosition)
	changeState(State.MOVE_PATH)


## updates stop timer depending on velocity
func updateStopTimer(delta : float):
	if velocity.length() <= speed / 5.0:
		stopTimer -= delta


## finds next point to patrol to and finds path there [br]
## does not go into patrol mode
func findNextPatrolPath(go_to_current_patrol_node : bool) -> bool:
	stopTimer = stopLimit
	if not go_to_current_patrol_node or not current_patrol_node:
		if patrol_path.is_empty():	# no nodes left to choose
			if not last_patrol_node:	# no past node stored
				if current_patrol_node:	# currently at a node
					last_patrol_node = current_patrol_node
					current_patrol_node = null
				changeState(State.IDLE)
				return false
			else:	# has past node stored
				patrol_path.append(last_patrol_node)
				last_patrol_node = current_patrol_node
			
		else:	# patrol path has nodes
			var next_node : PatrolNode	
			
			if random_path:
				next_node = patrol_path.pop_at(randi() % patrol_path.size())
			else:	# sequential path
				next_node = patrol_path.pop_front()
				
			if last_patrol_node:	# has past node stored
				patrol_path.append(last_patrol_node)
			
			last_patrol_node = current_patrol_node
			current_patrol_node = next_node
	
	if not current_patrol_node:
		changeState(State.IDLE)
		return false
	
	updatePath(current_patrol_node.global_position)
	return true
	

#STATE FUNCTIONs

func changeState(newState: State) -> bool:
	if newState == curState:
		return false
	#first, handle special behaviour coming out of any old state
	match curState:
		State.MOVE_PATH:
			path = null
			path_progress = 0
			targetObject = null
		State.MOVE_DIRECTION:
			bearing = Vector3(0,0,0)
			targetObject = null
		State.FOLLOW:
			bearing = Vector3(0,0,0)
		State.ATTACK:
			actionTimer = -1
		State.GATHER: 
			actionTimer = -1
		State.DEAD:
			return false
	
	#second, handle transition to new state
	
	enableMovementCollision(false)
	enableActionCollisionLayer(false)
	match newState:
		State.IDLE:
			enableMovementCollision(true)
			enableActionCollisionLayer(false)
			actionTimer = targetScanInterval
		State.MOVE_PATH:
			stopTimer = stopLimit
		State.MOVE_DIRECTION:
			pass
		State.FOLLOW:
			if (targetObject == null): return false
			actionTimer = -1
			stopTimer = stopLimit
		State.ATTACK:
			enableMovementCollision(false)
			enableActionCollisionLayer(true)
			actionTimer = attackRate
			#Attacks normally have targets, but no hard requirement to permit for AOE attacks
			pass
		State.GATHER:
			enableMovementCollision(false)
			enableActionCollisionLayer(true)
			#can only gather from a target resource deposit
			if (targetObject == null or not targetObject is ResourceDep): return false
			actionTimer = gatherRate
			pass
		State.DEAD:
			pass
		State.SPECIAL:
			pass
		State.PATROL:
			stopTimer = stopLimit
			if not findNextPatrolPath(true):
				return false
		State.ROAM:
			pass
		_: 
			#state not recognized is a failure
			return false
	
	curState = newState
	
	#if OS.is_debug_build(): print(name, " enters state ", curState)
	
	return true


func stateProcess(delta : float) ->void:
	match curState:
		State.IDLE:
			stateIdleFunction(delta)

		State.MOVE_PATH:
			#at end of path, update state
			updateStopTimer(delta)
			if arrivedAtNavTarget():
				if(targetObject == null or not is_instance_valid(targetObject)):
					changeState(State.IDLE)

				elif(targetObject is DynamicObj or targetObject is BuildingObj):
					changeState(State.ATTACK)
				elif(targetObject is ResourceDep):
					changeState(State.GATHER)
				else:
					changeState(State.IDLE)
			
	
		State.MOVE_DIRECTION:
			# movement handled in physics process
			pass
	
		State.FOLLOW:
			actionTimer -= delta
			updateStopTimer(delta)
			if actionTimer <= 0:
				updatePath(targetObject.global_position)
				actionTimer = pathfindInteral
			
			var distanceVec = targetObject.global_position - global_position
			# movement handled in physics process
			if((targetObject is DynamicObj or targetObject is BuildingObj)
				and attackType != null and distanceVec.length() < attackType.attackRange):
				changeState(State.ATTACK)
			elif(targetObject is ResourceDep and distanceVec.length() < 2.5):
				changeState(State.GATHER)
			
			#ADD STATE CHANGE FOR BEING NEAR ENOUGH TO TARGET
			
			pass
	
	
		State.ATTACK:
			if targetObject:
				var distanceVec = targetObject.global_position - global_position
				if attackType != null and distanceVec.length() >= attackType.attackRange:	# target moved out of range
					changeState(State.FOLLOW)
					# TODO: create function for when target goes out of attack range
					#		so that it can be overwritten in different units for different effect
					#		e.g. chase, give up, search new closest target etc
				else:
					actionTimer -= delta
					if actionTimer <= 0: #if attack timer expires, attack and reset timer
						attack()
						actionTimer = attackRate
				if targetObject:
					lookatPosition(targetObject.global_position)
			else:
				findNewAttackTarget()
	
		State.GATHER: 
			actionTimer -= delta
			if actionTimer <= 0:
				gather()
				actionTimer = gatherRate
			if targetObject:
				lookatPosition(targetObject.global_position)
	
		State.DEAD:
			actionTimer -= delta
			if actionTimer <= 0:
				despawnUnit()
			pass
	
		State.SPECIAL:
			pass
	
		State.PATROL:
			updateStopTimer(delta)
			# scan for enemies
			if actionTimer <= 0:
				actionTimer = targetScanInterval	
				findNewAttackTarget()
			actionTimer -= delta
			
			if arrivedAtNavTarget():
				findNextPatrolPath(false)
		
		State.ROAM:
			#roam behaviour goes here
			pass
		
		_:
			#unknown state catch
			pass
	pass


func stateIdleFunction(delta : float):
	actionTimer -= delta
	if patrol:
		if actionTimer <= 0:
			if not arrivedAtNavTarget():
				changeState(State.PATROL)


func statePhysicsProcess(delta : float):
	velocity = Vector3(0, velocity.y, 0)
	match curState:
		State.IDLE:
			pass

		State.MOVE_PATH:
			moveAlongNavPath(delta)
	
		State.MOVE_DIRECTION:
			velocity += speed * bearing
			
			turn_to_moving_dir(delta)
	
		State.FOLLOW:
			moveAlongNavPath(delta)
	
		State.ATTACK:
			pass
	
		State.GATHER: 
			pass
	
		State.DEAD:
			pass
	
		State.SPECIAL:
			pass
	
		State.PATROL:
			moveAlongNavPath(delta)
		
		State.ROAM:
			velocity += speed * bearing
			
			turn_to_moving_dir(delta)
		
		_:
			#unknown state catch
			pass
	# include gravity
	velocity.y -= gravity * delta
	move_and_slide()

#HELPER FUNCTIONs


# gets all detectable enemies in vision area
func findVisibleEnemies():
	var enemies = []
	for body in visionArea.get_overlapping_bodies():
		if body.has_method("takeDamage") and body.alignment != alignment:
			if "curState" in body:
				if body.curState != State.DEAD:
					enemies.append(body)
			else:
				enemies.append(body)
	return enemies

func findEnemiesInArea(area : Area3D):
	var enemies = []
	for body in area.get_overlapping_bodies():
		if body.has_method("takeDamage") and body.alignment != alignment:
			enemies.append(body)
	return enemies


func findNewAttackTarget() -> bool:
	
	#if OS.is_debug_build(): print(name, " finding new enemies")

	var enemies = findVisibleEnemies()
	if(enemies.is_empty()):
		# ADD ACTIONSET BSED BEHAVIOUR HERE (go back to patrol, etc)
		if current_patrol_node:
			changeState(State.PATROL)
		else:
			changeState(State.IDLE)
		
		return false
	else:
		# find closest enemy
		var minDistance = INF
		var newTarget = null
		for enemy in enemies:
			var newDistance = global_position.distance_to(enemy.global_position)
			if newDistance < minDistance:
				newTarget = enemy
				minDistance = newDistance
		setAttackTarget(newTarget)
		
		return true
	
	return false


## finds if arrived at target
## returns true if close to target or stuck for too long
func arrivedAtNavTarget() -> bool:
	var final_nav_point = navigationAgent.get_final_position()
	final_nav_point.y = global_position.y
	var output = global_position.distance_to(final_nav_point) <= 0.5 \
				or stopTimer <= 0.0	# too slow for too long / stuck
	return output


func moveAlongNavPath(delta):
	bearing = navigationAgent.get_next_path_position() - global_position
	bearing = bearing.normalized()
	velocity += speed * bearing
	
	turn_to_moving_dir(delta)


func select():
	actions.select()


# Mouse Clicks
func leftClickOn(click_position: Vector3):
	actions.parentClicked(false)
	if OS.is_debug_build(): print(name, " left clicked")


func rightClickOn(click_position: Vector3):
	actions.parentClicked(true)
	if OS.is_debug_build(): print(name, " right clicked")
	
	if Input.is_key_pressed(KEY_SHIFT): # SHIFT + MOUSE_BUTTON_RIGHT to track
		get_viewport().get_camera_3d().set_tracked_unit(self)
		if OS.is_debug_build(): print(name, " shift + right clicked, tracking started")


## enables or disables collision between units when moving
func enableMovementCollision(enable : bool):
	set_collision_layer_value(7, enable)
	set_collision_mask_value(7, enable)


## enables or disables collision between units when attacking or gathering
func enableActionCollisionLayer(enable : bool):
	set_collision_layer_value(6, enable)


func get_curState() -> int:
	return curState

func turn_to_moving_dir(delta : float):
	if bearing.length_squared() > 0.01:
		var target_dir = bearing.normalized()
		var current_rot = rotation.y
		var target_rot = atan2(target_dir.x, target_dir.z)
		rotation.y = lerp_angle(current_rot, target_rot, delta * 5.0)


## rotates object to look at point [br]
## ignores y component of position
func lookatPosition(position : Vector3):
	if targetObject:
		var target_dir = position - global_position
		var target_rot = atan2(target_dir.x, target_dir.z)
		rotation.y = target_rot


## populates patrol path with an array of nodes
func populatePatrolPath(nodes : Array[PatrolNode]):
	patrol_path = nodes.duplicate(false)


#SIGNAL HANDLING


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	#ensure target has NOT been deleted; if it has ,set to null and change behaviour
	if(targetObject == null or not is_instance_valid(targetObject)):

		targetObject = null
		match curState:
			State.ATTACK:
				findNewAttackTarget()
			State.GATHER: 
				changeState(State.IDLE) 
			State.FOLLOW: 
				changeState(State.IDLE)
	
	
	actions.actionSetProcess()
	
	stateProcess(delta)
	
	
	#ADD CALLS TO ANIMATION HERE (if needed)
	
	pass


func _physics_process(delta: float) -> void:
	statePhysicsProcess(delta)
