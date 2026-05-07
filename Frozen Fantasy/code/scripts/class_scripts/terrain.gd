extends WorldObj
class_name Terrain

"""
Functionality to include:
	heightmap terrain (generation probably happens elsewhere)
	In initialization, from generated heightmap, create mesh (including normal mods)
	
	Get height at any given point (su units can match it)
	
	when point clicked, sends signal to all selected units (in group "selected") to move to that point. 
	Can create spline paths between two specified points. 

	maybe more... 
"""

# child
@onready var floor = $NavigationRegion/Floor


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("terrain") #like main, can be queried fron anywhere
	
	pass # Replace with function body.



## returns the height value of the terrain at a specific 3d position
func getHeightAtPoint(point : Vector3) -> float:
	return floor.data.get_height(point)




func getPathBetween(pointA, pointB) -> Curve2D:
	var newCurve = Curve2D.new()
	
	if pointA is Vector3:
		pointA = Vector2(pointB.x, pointB.z)
	if pointB is Vector3:
		pointB = Vector2(pointB.x, pointB.z)
	
	newCurve.add_point(pointA)
	# CONSTRUCT CURVE BASED ON TERRAIN
	newCurve.add_point(pointB)
	
	
	return newCurve







# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
