extends Node2D

# for debug
export var disable = false

# mob type
onready var mob_type = get_node("/root/Main/Mob_Type")

# scene
onready var Player = get_node("/root/Main/Stage/Player")
onready var stage = get_node("/root/Main/Stage")
onready var map = get_node("/root/Main/Map")
onready var spawn_tile = get_node("/root/Main/Map/Spawnable_Tile")

# collision_tester
onready var collision_tester = load("res://Scenes/Overlap/collision_tester.tscn")

# mobs
onready var mob_array: Array
var mob = null

# child
onready var spawn_timer = $Timers/SpawnTimer

# rng
var rng = RandomNumberGenerator.new()

# stats
var close_radius: int # radius of area close to player
var moderate_radius: int # radius of area moderate distance to player
var far_radius: int # radius of area far from player

# default stats
export var max_spawn_radius: int = 50
export var min_spawn_radius: int = 10
export var spawn_rate: float = 1
export var max_spawn_time: float = 120 # maximum amount of time for a mob to spawn, in seconds
export var close_prob: int = 25 # probability of mobs spawning near player
export var moderate_prob: int = 35 # probability of mobs spawining moderate distance to player

# variables
enum distance {
	CLOSE,
	MODERATE,
	FAR
}
var section_radius: int # radius of each layer
var total_weight: int = 0 # spawn weights of all mobs combined

# trackers
var spawn_layer = distance.CLOSE
var spawn_time: float
var spawn_location: Vector2 = Vector2.ZERO

func _ready():
	for i in mob_type.TYPE.keys():
		var temp = i.to_lower()
		mob_array.append(load("res://Scenes/Enemies/" + temp + "/" + temp + ".tscn"))
	if (!disable):
		section_radius = (max_spawn_radius - min_spawn_radius) / 3
		close_radius = min_spawn_radius
		moderate_radius = min_spawn_radius +  section_radius
		far_radius = min_spawn_radius + 2 * section_radius
		for i in mob_array:
			var temp = i.instance()
			total_weight += temp.spawn_weight
			temp.queue_free()
		randomize_spawn_timer()
		spawn_timer.start()

func _process(delta):
	self.global_position = Player.position

func randomize_spawn_timer():
	rng.randomize()
	var random_number = rng.randf_range(0, max_spawn_time / 3)
	var spawn_time: float = max_spawn_time / (random_number + spawn_rate)
	spawn_timer.wait_time = spawn_time
	spawn_rate += 1

func generate_spawn_position():
	var spawnable = false
	var tester = collision_tester.instance()
	while (!spawnable):
		rng.randomize()
		var spawn_number = rng.randf_range(0,100)
		# determines which layer to spawn in
		if (spawn_number < close_prob):
			spawn_layer = distance.CLOSE
		elif (spawn_number < moderate_prob):
			spawn_layer = distance.MODERATE
		else:
			spawn_layer = distance.FAR
		# get spawn distance
		spawn_location.x = rng.randf_range(0, section_radius)
		match(spawn_layer):
			distance.CLOSE:
				spawn_location.x += close_radius
			distance.MODERATE:
				spawn_location.x += moderate_radius
			distance.FAR:
				spawn_location.x += far_radius
		# get rotation
		var rotation = rng.randf_range(0, 360)
		spawn_location = spawn_location.rotated(rad2deg(rotation))
		# convert position from local to global
		spawn_location += Player.position
		
		# test if position is spawnable
		var cell_pos = spawn_tile.world_to_map(spawn_location)
		var tile_id = spawn_tile.get_cellv(cell_pos)
		
		if tile_id >= 0: # inside map
			tester.global_position = spawn_location
			
			if tester.not_colliding():
				spawnable = true				
			else:
				spawnable = check_neighbouring(tester)
	tester.queue_free()

# check neighbouring cells for spawnable area
func check_neighbouring(tester):
	var x_pos = [+16, 0, -16]
	var y_pos = [+16, 0, -16]
	
	for x in x_pos:
		for y in y_pos:
			var temp_location = spawn_location
			temp_location.x += x
			temp_location.y += y
			tester.global_position = temp_location
			if tester.not_colliding():
				spawn_location = temp_location
				return true
	return false

func generate_mob_type():
	rng.randomize()
	var type_number = rng.randf_range(1, total_weight)
	for i in mob_array:
		var temp = i.instance()
		if type_number <= temp.spawn_weight:
			mob = i.instance()
			mob.global_position = spawn_location
			break
		else:
			type_number -= temp.spawn_weight
		temp.queue_free()

func spawn_mob():
	var spanable = true
	generate_mob_type()
	generate_spawn_position()
	stage.add_child(mob)


func _on_SpawnTimer_timeout():
	spawn_mob()
	randomize_spawn_timer()
	spawn_timer.start()

