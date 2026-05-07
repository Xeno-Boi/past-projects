extends KinematicBody2D

export (PackedScene) var med_scene

signal heal

var game_started = false

# movement variables
export var maxSpeed = 4
export var sprintSpeed = 6
export var acceleration = 50
export var friction = 50
var velocity = Vector2.ZERO
var input_vector = Vector2.ZERO
var sprint = false

# animation variables
onready var stage = get_tree()
onready var hud = get_node("/root/Main/Label/HUD")

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")

onready var lookDirection = $direction
onready var detector = $direction/detector

# item interact variables
var grabbed = "none"
var carrying = null
var medicine




# Called when the node enters the scene tree for the first time.
func _ready():
	
	# set movement variables
	acceleration *= 100
	friction *= 100
	maxSpeed *= 100
	sprintSpeed *= 100


func _physics_process(delta):
	if (game_started):
		in_game(delta)
	else:
		not_in_game(delta)

func not_in_game(delta):
		self.position.x = -30
		if Input.is_action_just_pressed("sprint"):
			hud.StartButton_pressed()
		

func in_game(delta):
	if Input.is_action_just_pressed("restart"):
		hud.death = 3
	# movement
	input_vector.x = Input.get_action_raw_strength("move_right") - Input.get_action_raw_strength("move_left")
	input_vector.y = Input.get_action_raw_strength("move_down") - Input.get_action_raw_strength("move_up")
	input_vector = input_vector.normalized()
	if Input.is_action_just_pressed("sprint"):
		sprint = true
	if Input.is_action_just_released("sprint"):
		sprint = false
	
	
	if input_vector != Vector2.ZERO:
		# animation
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationTree.set("parameters/Grab_Idle/blend_position", input_vector)
		animationTree.set("parameters/Grab_Run/blend_position", input_vector)
		if grabbed == "none":
			animationState.travel("Run")
		else:
			animationState.travel("Grab_Run")
		# movement
		velocity += input_vector * acceleration * delta
		if sprint:
			velocity = velocity.clamped(sprintSpeed)
		else:
			velocity = velocity.clamped(maxSpeed)
		# hitbox direction
		lookDirection.rotation_degrees = rad2deg(input_vector.angle())
	else:
		# animation
		if grabbed == "none":
			animationState.travel("Idle")
		else:
			animationState.travel("Grab_Idle")
		# movement
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
		
	velocity = move_and_slide(velocity)
	# move player to bottom of stage
	get_parent().move_child(self, get_parent().get_child_count()-1)
	
	# interaction
	if Input.is_action_just_pressed("interact"):
		if grabbed != "none":
			var collider = get_Closest_collider()
			if medicine != null:	# holding medicine
				if collider is Bed:		# facing bed
					var patient = collider.patient
					if patient != null && !patient.healed:	# bed has unhealed patient
						if grabbed.begins_with(patient.type):
							connect("heal", collider, "heal")
							emit_signal("heal")
							disconnect("heal", collider, "heal")
				# clear hand
				medicine.queue_free()
				medicine = null
			elif carrying != null:	# holding patient
				if collider is Bed && (collider.type.match(carrying.type) || collider.type.match("icu")) && collider.patient == null && !carrying.healed:
					stage.call_group("colliders", "player_releasing_on_bed", carrying, get_Closest_collider())
				else:
					stage.call_group("colliders", "player_releasing_on_ground", carrying)
			# clear hand
			grabbed = "none"
			carrying = null
		else:
#			stage.call_group("patients", "_on_DeathTimer_patient_dies")	# debug
			stage.call_group("colliders", "player_interacting", get_Closest_collider())	

# detect if player can grab an object
func _on_detector_body_entered(body):
	stage.call_group("colliders", "player_colliding", get_Closest_collider())

func _on_detector_body_exited(body):
	stage.call_group("colliders", "player_stop_colliding")


# grabbing medicine
func _on_LightBox_grabbed_light_med():
	load_med_on_player("light")
	
func _on_ModerateBox_grabbed_moderate_med():
	load_med_on_player("moderate")

func _on_SevereBox_grabbed_severe_med():
	load_med_on_player("severe")

# render medicine above player's head
func load_med_on_player(type):
	medicine = med_scene.instance()
	add_child(medicine)
	medicine.position.x = 0
	medicine.position.y = -80
	medicine.animation = type
	medicine.play()
	grabbed = type + "_med"


func grabbed_patient(type, object):
	grabbed = type + "_patient"
	carrying = object
	
func get_Closest_collider():
	var colliders = detector.get_overlapping_bodies()
	if colliders.empty():
		return null
	else:
		var closest = colliders[0]
		for object in colliders:
			if self.position.distance_squared_to(closest.position) > self.position.distance_squared_to(object.position):
				closest = object
		return closest
		
func reset():
	sprint = false
	grabbed = "none"
	carrying = null
	game_started = false
	animationState.travel("idle")
	if medicine != null:
		medicine.queue_free()
