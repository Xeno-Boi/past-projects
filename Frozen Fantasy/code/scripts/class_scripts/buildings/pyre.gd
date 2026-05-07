extends PlayerBuilding

"""
Functionality:
	Adds functionality unique to Pyre on top of PlayerBuildings
	
	Building functions:
		- checks if a point is within the area of the pyre
		- modified death function to disable all nearby buildings
		
	Visual:
		- when selected, shows covered area

"""

# properties
@export var effective_radius : float = 1.0
var isPyreType = true	## A variable to check if an object is a pyre. Value of this does not matter


# child
@onready var effective_area_mesh = $EffectiveAreaMesh


func _ready() -> void:
	super._ready()
	add_to_group("pyre_buildings")	# keeps track of all pyre buildings
	# setup effective area mesh
	effective_area_mesh.mesh.top_radius = effective_radius
	effective_area_mesh.mesh.bottom_radius = effective_radius
	#var material = effective_area_mesh.get_surface_override_material(0)
	#material.set_shader_parameter("base_y", global_position.y)
	#material.set_shader_parameter("color", Color(1.0, 0.0, 0.0, 1.0))
	
	var animation = $evil_stone/AnimationPlayer
	animation.get_animation("Take 001").loop = true
	animation.play("Take 001")
	

func _process(delta: float) -> void:
	super._process(delta)
	if not self.is_in_group("pyre_selected"):
		effective_area_mesh.hide()
	

# input handlers

func leftClickOn(click_position : Vector3):
	defs.clearGroup(self, "selected")
	select()



## selects pyre
func select():
	self.add_to_group("pyre_selected")
	effective_area_mesh.show()


func kill():
	deactivateSurroundingBuildings()
	super.kill()


# helper functions

## checks if a provided position is inside the effective area of the pyre
## checks in the same y-level
func isInArea(position : Vector3) -> bool:
	position.y = global_position.y
	var distance = global_position.distance_to(position)
	if distance <= effective_radius:
		return true
	return false


## finds and activates all nearby buildings in the same alignment
func activateSurroundingBuildings():
	for building in get_tree().get_nodes_in_group("buildings"):
		var building_xz_position = building.global_position
		building_xz_position.y = global_position.y
		if global_position.distance_to(building.global_position) <= effective_radius:	# near pyre
			if alignment == building.alignment:	# same alignment
				building.activate()


## finds and deactivates all nearby buildings in the same alignment
func deactivateSurroundingBuildings():
	remove_from_group("pyre_buildings")
	for building in get_tree().get_nodes_in_group("buildings"):
		var building_xz_position = building.global_position
		building_xz_position.y = global_position.y
		if global_position.distance_to(building.global_position) <= effective_radius + 5:	# near pyre
			if alignment == building.alignment:	# same alignment
				if building != self and not building.is_in_group("pyre_buildings"):	# not a pyre
					if not defs.inPyreEffectiveArea(self, building.global_position, building.alignment):	# not near another friendly pyre
						building.deactivate()
