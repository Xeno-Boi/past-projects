extends Node2D

signal mob_hit

# scene
onready var Player = get_parent()

# animation players
onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")

# weapon type
onready var weapon_type = get_node("/root/Main/Weapon_Type")

# trackers
var mob_hit: bool = false

func _ready():
	animationState.travel("Idle")
	
func match_weapons(weapon):
	match(weapon.type):
		weapon_type.MELEE.SINGLE_HANDED_SWORD:
			return "SHS"
		weapon_type.MELEE.LONGSWORD:
			return "Longsword"
		weapon_type.MELEE.GREATSWORD:
			return "Greatsword"
		weapon_type.MELEE.AXE:
			return "Axe"
		weapon_type.MELEE.SPEAR:
			return "Spear"
		weapon_type.MELEE.SWORD_AND_SHIELD:
			return "SHS"
		weapon_type.MELEE.HOLY_BLADE:
			return "Longsword"

func set_direction(weapon, input_position):
	var target = match_weapons(weapon)
	animationTree.set("parameters/" + target + "_Attack/blend_position", input_position)


func attack(weapon):
	var target = match_weapons(weapon)
	animationState.travel(target + "_Attack")

func attack_animation_finished():
	animationState.travel("Idle")
	mob_hit = false
	
func stop_animation():
	animationState.travel("Idle")
	mob_hit = false


func _on_Hitbox_area_entered(area):
	# first collision
	if (!mob_hit):
		emit_signal("mob_hit")
	mob_hit = true
