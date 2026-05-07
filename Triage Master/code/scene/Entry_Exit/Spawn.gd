extends Node2D

# patient nodes
var light = load("res://scene/Patient/lightPatient/LightPatient.tscn")
var moderate = load("res://scene/Patient/moderatePatient/ModeratePatient.tscn")
var severe = load("res://scene/Patient/severePatient/SeverePatient.tscn")
var spawn = load("res://scene/Entry_Exit/Spawn.tscn")

var moveSpeed = 20
var move_direction = 0
var spawnPos = self.position
var patientSpawnCount = 0 # Use this counter to determine when to spawn each level of patient.
var patient
var rng = RandomNumberGenerator.new()
export var initialSpawn = 1	# number of patients spawn when game starts

func _ready():
	rng.randomize()


func _process(delta):
	MovementLoop(delta)


func MovementLoop(delta):
	var children = self.get_child_count()
	if children != 0:
		children = self.get_children()
		for child in children:
			if child.get_class() == "KinematicBody2D": # patient model
				var detection = child.get_node("Vision")
				if !detection.is_colliding():
					child.position.x += 0.5


func _on_SpawnTimer_timeout():
	var spawnNumber = rng.randf_range(0,100)
	# The following loop will spawn a severe patient almost every 5, and a moderate character almost every 4. There is some overlap to feel a little more random.
	if (spawnNumber < 25):	# 25%
		patient = severe.instance()
	elif(spawnNumber < 55):	# 30%
		patient = moderate.instance()
	else:	# 45%
		patient = light.instance()
	patient.position = spawnPos

	# Don't let more than 5 spawn at a time.
	if patientSpawnCount < 5:
		add_child(patient)
		patientSpawnCount += 1
	$SpawnTimer.start()
	#TODO Each Patient needs to follow the path to the end of the WaitingRoomPathFollow. 

func stop():
	$SpawnTimer.stop()
	patientSpawnCount = 0


func _on_HUD_start_game():
	$SpawnTimer.start()
	despawnWaitingPatients()
	for i in initialSpawn:	# spawn patients immediately
		_on_SpawnTimer_timeout()
		yield((get_tree().create_timer(1)), "timeout")
	
	
func despawnWaitingPatients():
	var children = self.get_child_count()
	if children != 1:
		children = self.get_children()
		for child in children:
			if child.get_class() == "KinematicBody2D": # Despawn all waiting patients, but not the spawn timer.
				self.remove_child(child)
				patientSpawnCount -= 1

