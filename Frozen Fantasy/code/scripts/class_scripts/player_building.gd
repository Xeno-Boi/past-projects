extends BuildingObj
class_name PlayerBuilding


"""
Functionality:
	Adds functionality unique to player buildings. 
	
	Building Placement:
		- placement blocked by not being near a pyre, or by overlapping with another building
		- shader to highlight right/wrong placement
		- quieryable to see if in ok location
		- Method to place. Once placed, can't be moved
		
	Management:
		- ability to destroy
		- other??

"""


@export var building_cost: Dictionary = {"wood": 0, "stone": 0, "fire_stone": 0, "new_fire_shard": 0}

var main

# signals
signal building_placed(building_type: String)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	alignment = true
	
	main = get_tree().root.get_node("main")
	
	play_building_animation("idle")
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super._process(delta)
	
	pass


# input handle
func leftClickOn(click_position : Vector3):
	if defs.DEBUG_MODE:
		print(name + " active: " + str(active))


func pay_for_building():
	for resource in building_cost.keys():
		main.add_resource(resource, -building_cost[resource])
	emit_signal("building_placed", building_type)


func play_building_animation(name = "idle"):
	var anim = get_node_or_null("AnimatedModel/Animation")
	if anim and anim is AnimationPlayer and anim.has_animation(name):
		anim.play(name)
