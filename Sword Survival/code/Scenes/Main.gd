extends Node2D
onready var minimap = preload("res://Scenes/Map/minimap.tscn")
var mMap
# variables
export var weapon_despawn_time: int
export var max_wandering_mobs: int

# trackers
var wandering_mobs: int = 0


func can_wander():
	return wandering_mobs < max_wandering_mobs

func start_wander():
	wandering_mobs += 1
	
func stop_wandering():
	wandering_mobs -= 1


