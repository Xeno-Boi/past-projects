extends StaticObj
class_name BuildingObj

"""
Functionality:
	includes room for differences between player and enemy buildings (handled in sublasses)
	
	includes general attributes -- health, dimensions, etc. 
	Building attributes are handled with non-inherieted classes, so provide behaviour for checking if they have it, and calling it


"""

@export var building_type: String = ""
@export var maxHealth : float = 1
@onready var health : float = maxHealth
var alignment : bool = true  #like dynamicObj; true = player, false = not
var active: bool = true # this is for building placement -- building only functions while active.
@export var extensions: Array[BuildingExtension]

@export var mouseHitbox : Area3D = null #again, like dynmaicObj. Names are intentinally the same -- keep it that way!!
@onready var healthBar = $OverheadDisplay/SubViewport/HealthBar

# signals
signal destroyed(building)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("buildings")
	super._ready()



func takeDamage (damageVal : float, attacker : DynamicObj = null) -> void:
	#print(name)
	#print("taking damage")
	health -= damageVal
	healthBar.value = (health/maxHealth)*100
	#print("health: ", health)
	
	for ext in extensions:
		ext.handleDamage()
	
	
	if(health <= 0):
		kill()
	
	#ADD BEHAVIOUR WHEN IMPLEMENTING
	pass


func activate():
	active = true


func deactivate():
	active = false


## kills building
## if override, call super.kill() at the end
func kill():
	for ext in extensions:
		ext.handleDeath()
	
	emit_signal("destroyed", self)
	#any special behaviour for handling death here
	
	queue_free()


# input handle
func rightClickOn(click_position : Vector3):
	if defs.DEBUG_MODE:
		kill()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super._process(delta)
	
	if (not active): 
		return
	
	#process each extension
	for ext in extensions:
		ext.extensionProcess(delta)
	
	pass
