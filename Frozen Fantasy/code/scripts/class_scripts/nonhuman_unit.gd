extends MeshInstance3D
class_name NonHumanoid

"""
For units that aren't humanoid. Each will need to have their animation individually defined (or subclassed)

We might, for example, subclass a dog for this then make 3 categories, each of which share animations
"""


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
