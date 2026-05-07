extends Node2D

# scene
onready var map = get_node("/root/Main/Map")
onready var travel_tile = get_node("/root/Main/Map/Spawnable_Tile") # area that can be spawned in also can be traveled to

# child
onready var start_position: Vector2 = global_position
onready var target_position: Vector2 = global_position
onready var timer = $Timer

# stat
export var wander_range:int = 32

# rng
var rng = RandomNumberGenerator.new()

# trackers
var travelable: bool = false

func _ready():
	rng.randomize()

func update_target_position():
	start_position = global_position
	travelable = false
	while (!travelable):
		var target_vector = Vector2(rng.randf_range(-wander_range, wander_range), rng.randf_range(-wander_range, wander_range))
		target_position = start_position + target_vector
		
		# test if position is travelable
		var cell_pos = travel_tile.world_to_map(target_position)
		var tile_id = travel_tile.get_cellv(cell_pos)
		
		if tile_id >= 0: # travelable
			travelable = true

func get_new_target():
	update_target_position()
	return target_position

func get_time_left():
	return timer.time_left
	
func start_timer(duration):
	timer.start(duration)
