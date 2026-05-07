extends BuildingExtension
class_name SpawnerBuilding

"""
Framework for spawning to a certain amount of a designated unit regularly at a time interval
NOT an inheritance unit, like AOE building. 
Keeps pointers to units it spawned to count the amount. 
"""

var spawning : bool = false
var spawnTimer : float = -1
@export var spawnPoint : Area3D = null
@export var spawnRate : float = 3.0
@export var maxChildren : int = 5
var childCount : int = 0

@export var childType : PackedScene = null #specify with each building type

var unit_name_counter = {}

signal killed()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawning = true
	spawnTimer = spawnRate
	add_to_group("spawner_building_extensions")
	pass # Replace with function body.


func spawnChild() -> void:
	if(childCount < maxChildren):
		spawnTimer = spawnRate
		
		var newChild = childType.instantiate()
		newChild.setParent(self)
		childCount+= 1
		#add child to global roster of units
		get_tree().root.get_node("main").get_node("Units").add_child(newChild)
		# readable unit name
		var base_name = newChild.name
		if base_name.contains("@"):
			base_name = base_name.split("@")[0]
		if not unit_name_counter.has(base_name):
			unit_name_counter[base_name] = 1
		else:
			unit_name_counter[base_name] += 1
		newChild.name = base_name + str(unit_name_counter[base_name])
		# connect signal to goal list (killed signal)
		get_tree().root.get_node("main/UI/GoalList").connect_unit_signals(newChild)
		newChild.connect("killed", Callable(self, "_onChildKilled"))
		newChild.global_transform.origin = spawnPoint.global_transform.origin
		
		var exitDir =Vector2.from_angle(randf() * TAU) * newChild.speed
		var exitTargetPosition = Vector3(global_position.x+exitDir.x, global_position.y, global_position.z + exitDir.y)
		newChild.followPath(exitTargetPosition)
		
		
	
	if(childCount == maxChildren):
		spawnTimer = -1
		spawning = false
	
	pass


func _onChildKilled(unit) ->void:
	childCount -=1
	if !spawning:
		spawning = true
		spawnTimer = spawnRate
	pass



# Called every frame. 'delta' is the elapsed time since the previous frame.
func extensionProcess(delta: float) -> void:
	super.extensionProcess(delta)
	
	
	if spawning:
		spawnTimer -= delta
		if (spawnTimer <= 0): spawnChild() 
		
		
	
	pass
