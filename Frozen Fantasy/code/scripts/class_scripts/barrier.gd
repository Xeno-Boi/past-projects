extends WorldObj
class_name Barrier

@onready var models := [
	$IceCluster,
	$IceCluster,
	$IceCluster2,
	$IceCluster2,
	$IceCluster3,
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	var index = randi() % models.size()
	models[index].visible = true
	super._ready()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super._process(delta)


"""
Functionality:
	barriers are static workd objects which prevent movement through them
	Should be able to come in several shapes and forms with varying meshes & sizes

"""
