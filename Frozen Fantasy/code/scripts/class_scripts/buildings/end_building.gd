extends BuildingExtension
class_name EndBuilding

var endTimer = 5.0
@onready var endParticles : GPUParticles3D = $EndParticles


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not endParticles.emitting:
		endParticles.emitting = true
	
	
	endTimer -= delta
	
	if endTimer <= 0:
		get_tree().root.get_node("main").endGame(true)
	
	pass
