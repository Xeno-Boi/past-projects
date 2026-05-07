extends Node2D

signal finish_spawning

# scene
onready var stage = get_node("/root/Main/Stage")
onready var mob = get_parent()

# weapon type
onready var weapon_type = get_node("/root/Main/Weapon_Type")

# random
var rng = RandomNumberGenerator.new()
export var spawn_percentage: int # max 100
export var melee_spawn_rate: int # max 10
export var ranged_spawn_rate: int # max 10

# weapon preload
var weapons_preload: Array

var weapon_to_spawn


func spawn_weapon():
	rng.randomize()
	# if spawn weapon
	var number = rng.randf_range(0, 100)
	if number <= spawn_percentage:
		# type of weapon to spawn
		number = rng.randf_range(0, 10)
		var spawn_type
		if number <= melee_spawn_rate:
			# spawn melee
			spawn_type = weapon_type.TYPE.MELEE
		elif number <= (melee_spawn_rate + ranged_spawn_rate):
			# spawn ranged
			spawn_type = weapon_type.TYPE.RANGED
		else:
			spawn_type = weapon_type.TYPE.MAGIC
		
		# preload every weapon of type
		match(spawn_type):
			weapon_type.TYPE.MELEE:
				for i in weapon_type.MELEE.keys():
					var temp = i.to_lower()
					weapons_preload.append(load("res://Scenes/Weapons/Melee/" + temp + ".tscn"))
			weapon_type.TYPE.RANGED:
				for i in weapon_type.RANGED.keys():
					var temp = i.to_lower()
					weapons_preload.append(load("res://Scenes/Weapons/Ranged/" + temp + ".tscn"))
			weapon_type.TYPE.MAGIC:
				for i in weapon_type.MAGIC.keys():
					var temp = i.to_lower()
					weapons_preload.append(load("res://Scenes/Weapons/Magic/" + temp + ".tscn"))
		# choose specific weapon to spawn
		var total_weight = 0
		for i in weapons_preload:
			var temp = i.instance()
			total_weight += temp.spawn_weight
			temp.queue_free()
		
		number = rng.randf_range(0, total_weight)
		for i in weapons_preload:
			var temp = i.instance()
			if number <= temp.spawn_weight:
				weapon_to_spawn = i.instance()
				weapon_to_spawn.status = weapon_to_spawn.STATUS.ON_GROUND
				weapon_to_spawn.global_position = mob.position
				break
			else:
				number -= temp.spawn_weight
			temp.queue_free()
		# spawn weapon
		stage.add_child(weapon_to_spawn)
	mob.finish_weapon_spawning()
