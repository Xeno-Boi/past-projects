extends Node3D

"""
Deals with world events and weather. 
Spawns enemies, etc. 

May apply buffs/debuffs to units

"""

@onready var snowParticles = $WeatherParticles
@onready var light = $DirectionalLight3D
@onready var ambient_light = $AmbientLight


# properties
@export var day_night_cycle_speed : float = 190.0	## in seconds
@export var sunset_color : Color = Color(1.0, 1.0, 1.0)
var light_color_gradiant : Gradient


var storminess : float = 0.0

const snowflake_ratio_min = 0.2
const snowflake_ratio_max = 1.0
const snowflake_turbulence_strength_min = 0.04
const snowflake_turbulence_strength_max = 0.2
const snowflake_gravity_min = Vector3(-5,-15,-5)
const snowflake_gravity_max = Vector3(-15,-45,-15)
var sky_color_grad = Gradient.new()


var Events = load("res://scripts/behavioural_scripts/world_event.gd")

var eventSequence : Array = [
	Events.PlayerReinforcements,
	Events.PyreRaid,
	Events.Calm,
	Events.EnemyReinforcements,
	Events.ReplenishResources,
	Events.PyreRaid,
	Events.Calm,
]

var eventTypes : Array = [
	Events.PyreRaid,
	Events.Calm,
	Events.EnemyReinforcements,
	Events.PlayerReinforcements,
	Events.ReplenishResources,
]




enum EventPhase {
	NORMAL = 0,
	PRE_EVENT = 1,
	MID_EVENT = 2,
	POST_EVENT = 3
}

var phaseAttributes := [
	{
		"phase" : EventPhase.NORMAL,
		"storm" : 0.2,
		"transitionPerSec" : 0.01,
		"duration" : 80.0,
	},
	{
		"phase" : EventPhase.PRE_EVENT,
		"storm" : 0.5,
		"transitionPerSec" : 0.02,
		"duration" : 30.0,
	},
	{
		"phase" : EventPhase.MID_EVENT,
		"storm" : 1.0,
		"transitionPerSec" : 0.04,
		"duration" : 60.0,
	},
	{
		"phase" : EventPhase.POST_EVENT,
		"storm" : 0.0,
		"transitionPerSec" : -0.05,
		"duration" : 20.0,
	},
	
]

#used for transitioning from one to the next
var event_phase_timer : float = 80.0


var phaseIndex : int = 0
var curAttributes = phaseAttributes[0]


#stores the details of the event currently going on
var curEvent = null


func _input(event: InputEvent) -> void:
	if Input.is_key_pressed(KEY_N):
		setBaseLightColor(Color(0, 0, 1))



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sky_color_grad.add_point(0.0, Color(1,1,1))
	sky_color_grad.add_point(0.2, Color(0.92,0.92,1))
	sky_color_grad.add_point(0.5, Color(1.0,0.8,0.9))
	sky_color_grad.add_point(0.9999, Color(0.7,0.7,1)) #weird glitch where it thinks 1 is white; setting 0.999 stops it interping towards that
	sky_color_grad.add_point(1.0, Color(0.7,0.7,1))

	# set up day and night cycle
	day_night_cycle_speed = clampf(day_night_cycle_speed, 0.1, INF)
	light_color_gradiant = Gradient.new()
	light_color_gradiant.set_color(0, Color(sunset_color))	# sun set
	light_color_gradiant.set_color(1, Color(1.0, 1.0, 1.0))	# midday
	# set up ambient light
	ambient_light.light_color = light.light_color
	ambient_light.rotation.x = light.rotation.x + PI
	ambient_light.rotation.y = light.rotation.y
	ambient_light.rotation.z = light.rotation.z + PI
	ambient_light.light_energy = 0.01


func change_storminess(newStorminess :float) -> void:
	
	storminess = newStorminess
	
	snowParticles.amount_ratio = lerp(snowflake_ratio_min,snowflake_ratio_max, storminess)
	snowParticles.process_material.turbulence_noise_strength = lerp(snowflake_turbulence_strength_min, snowflake_turbulence_strength_max, storminess)
	snowParticles.process_material.gravity = lerp(snowflake_gravity_min,snowflake_gravity_max, storminess)
	
	light.light_color = sky_color_grad.sample(storminess)
	
	
	pass


func changePhase() ->void:
	match phaseIndex:
		0:  #normal -> pre
			
			if(eventSequence.size() != 0):
				curEvent = eventSequence.pop_front().new()
			else:
				curEvent = eventTypes[randi() % eventTypes.size()].new()
			
			add_child(curEvent)
			curEvent.prepareEvent()
			
			#NOTIFY PLAYER WHAT'S BEGINNING
			
			pass
			
		1:  #pre -> mid
			
			curEvent.startEvent()
			
			
			#NOTIFY THE EVENT HAS HIT
			pass
			
		2:  #mid -> post
			
			curEvent.cleanUpEvent()
			
			#NOTIFY PLAYER ("enemies are dispersing" etc.)
			pass
			
		3:  #post -> normal
			
			curEvent.queue_free()
			curEvent = null
			phaseIndex = -1
			pass
	
	phaseIndex += 1
	
	curAttributes = phaseAttributes[phaseIndex]
	event_phase_timer = curAttributes.duration
	
	pass
	




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	
	event_phase_timer -= delta
	if(event_phase_timer < 0):
		changePhase()


	if(curAttributes.transitionPerSec < 0 and storminess > curAttributes.storm):
		change_storminess(storminess + curAttributes.transitionPerSec*delta)
	elif(storminess < curAttributes.storm):
		change_storminess(storminess + curAttributes.transitionPerSec*delta)
	
	if(phaseIndex == 2):
		curEvent.eventProcess(delta)
		if(curEvent.earlyEndCondition()):
			changePhase()
	
	"""
	# day and night cycle
	ambient_light.rotation.x += (2 * PI) * delta / (day_night_cycle_speed)
	var color_value = sin(light.rotation.x + PI)	# -1 -> midnight, 1 -> midday
	light.light_energy = (color_value + 1) / 2
	light.light_color = light_color_gradiant.sample(clamp(color_value, 0, 1))
	ambient_light.rotation.x += (2 * PI) / day_night_cycle_speed * delta
	"""

# helpers
## changes base light color
func setBaseLightColor(color : Color):
	light_color_gradiant.set_color(0, color * 0.5 + sunset_color * 0.5)
	light_color_gradiant.set_color(1, color)
	ambient_light.light_color = color
