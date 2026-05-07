extends WorldObj
class_name ResourceDep

@export var resource_type: String = "" 
#Types: "wood", "stone", "fireStone", "food, "newFire", (more go here if we want) 

@export var resource_count: int #set for each scene. -1 = infinite
@onready var cur_resources : int = resource_count
var exhausted = false

@export var replenishable : bool = true

@export var mouseHitbox : Area3D # used for clicking

@onready var statusIndicatorShader : ShaderMaterial = $StatusIndicator.get_active_material(0)
const activeColor = Color("17ee9b4b")
const inactiveColor = Color("f540474b")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("resource_deposits")
	super._ready()


func take_resource(amount=1):
	
	if(exhausted):
		return #do nothing if exhausted
	
	if(cur_resources != -1):
		#deplete resources, cap gathering at remaining amount
		amount = min(amount, cur_resources)
		cur_resources-= amount
	
	if(cur_resources == 0):
		exhausted = true
		statusIndicatorShader.set_shader_parameter("color", inactiveColor)
		
		pass
	
	
	get_tree().root.get_node("main").add_resource(resource_type, amount)
	
	
	
	#add behaviour for adding the amount to the main scene's resource pool
	pass



func getExhausted() ->bool:
	return exhausted


func replenish() -> void:
	if not replenishable: return
	
	cur_resources = resource_count
	statusIndicatorShader.set_shader_parameter("color", activeColor)
	exhausted = false

	pass



# callback function to when being clicked
func leftClickOn(click_position: Vector3):
	for node in get_tree().get_nodes_in_group("selected"):
		if (node is DynamicObj):
			node.setGatherTarget(self)
