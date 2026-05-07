extends BuildingExtension
class_name AOEBuilding


"""
Functionality:
	provides abstract for an area which applies an effect on surrounding units of a certain kind
	NOT an inheritance class -- an attribute
	Specifics happen in subclassing

"""



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func extensionProcess(delta: float) -> void:
	super.extensionProcess(delta)
	pass
