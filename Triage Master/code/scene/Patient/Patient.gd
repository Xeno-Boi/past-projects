extends KinematicBody2D

signal grabbed_patient
signal patient_death

class_name Patient

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var player = get_node("/root/Main/stage/Player")
onready var stage = get_node("/root/Main/stage")
onready var spawn = get_node("/root/Main/Spawn")
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var deathTimer = $DeathTimer
var type = "light"
var on_bed = false
var healed = false
var bed = null
var exiting = false
var dead = false


func _ready():
	$Pickup.visible_characters = 0
	$HealStatus.visible_characters = 0
	deathTimer.set_as_toplevel(true)
	# set_collision_layer_bit(4, true)  # for debugging
	add_to_group("colliders", true)
	add_to_group("patients", true)
	connect("grabbed_patient", player, "grabbed_patient")
	# initialize animation
	animationTree.set("parameters/Idle/blend_position", Vector2(1,0))
	animationTree.set("parameters/Healed_Idle/blend_position", Vector2(1,0))
	animationState.travel("idle")

func _process(delta):
	if !dead:
		if self.get_parent() == spawn:
			if !self.get_node("Vision").is_colliding():
				animationState.travel("run_right")
			else:
				animationState.travel("Idle")
		elif self.get_parent() == player && player.input_vector != Vector2.ZERO:
			animationTree.set("parameters/Idle/blend_position", player.input_vector)
			animationTree.set("parameters/Healed_Idle/blend_position", player.input_vector)
		if (exiting):
			position.y -= 1
		deathTimer.global_position = self.global_position
		if self.rotation_degrees != 0:
			deathTimer.global_position.y -= 30
		else:
			deathTimer.global_position.y -= 105
	if get_parent() == player:
		$Pickup.visible_characters = 0
	


func player_colliding(object):
	if !dead:
		if object == self:
			$Pickup.visible_characters = -1
		
func player_stop_colliding():
	if !dead:
		$Pickup.visible_characters = 0
#
	
func player_interacting(object):
	if !dead:
		if object == self:
			set_collision_layer_bit(4, false)
			# animation
			if healed:
				animationState.travel("healed_picked_up")
			else:
				animationState.travel("picked_up")
			# move to player
			self.get_parent().remove_child(self)
			player.add_child(self)
			self.position.y = -42
			self.position.x = -7
			emit_signal("grabbed_patient", type, self)

func player_releasing_on_ground(object):
	if object == self:
		if healed:
			set_collision_layer_bit(4, true)
			animationState.travel("Healed_Idle")
		else:
			animationState.travel("idle")
		# move to stage
		player.remove_child(self)
		stage.add_child(self)
		self.position = player.position
		
func player_releasing_on_bed(object, collider):
	if object == self:
		bed = collider
		animationState.travel("in_bed_waiting")
		# move self to bed
		player.remove_child(self)
		bed.add_child(self)
		self.position = Vector2.ZERO
		self.rotation_degrees = bed.rotate
		# update properties
		on_bed = true
		bed.patient = self
		# start heal for icu bed
		if bed.type.match("icu"):
			heal()

func heal():
	deathTimer.end()
	animationState.travel("healed_in_bed_waiting")

func finished_treating():
	healed = true
	$HealStatus.visible_characters = -1
	exit_bed()
	spawn.patientSpawnCount -= 1

func exit_bed():
	# move self away from bed
	bed.remove_child(self)
	stage.add_child(self)
	# place patient next to bed
	self.rotation_degrees = 0
	self.position = bed.position
	if bed.type.match("icu"):
		self.position.x -= 50
	elif ["light", "severe"].has(bed.type):
		self.position.y -= 50
	else:
		self.position.y += 50
	bed.patient = null
	bed = null
	
func exit_map(object):
	if object == self:
		remove_from_group("colliders")
		animationState.travel("healed_run_up")
		exiting = true
		position.x = get_node("/root/Main/ExitArea").position.x
	
func despawn_after_leaving(object):
	if object == self:
		despawn()
		

func despawn():
	queue_free()

func _on_DeathTimer_patient_dies():
	dead = true
	$death.play()
	$Pickup.visible_characters = 0
	# release from player
	if get_parent() == player:
		player.grabbed = "none"
		player.carrying = null
		player_releasing_on_ground(self)
	elif get_parent() == bed:
		exit_bed()
	animationState.travel("die")
	self.collision_layer = 0
	connect("patient_death", get_node("/root/Main/Label/HUD"), "on_patient_death")
	emit_signal("patient_death")
	
