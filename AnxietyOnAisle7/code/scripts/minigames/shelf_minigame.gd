extends Node2D


# properties
@export var minigame : int = defs.MINIGAME.SHELF_GAME
var background_start_x : float
var background_end_x : float
@export var spawning_items : Array[ShelfMinigameItem] = []
@export var min_spawn_time : float = 0.5
@export var max_spawn_time : float = 1.5
@export var gravity : float = 800.0
var gravity_multiplier : float = 1.0
@export var items_needed : int = 2	## item needed to be collected to win
var despawn_y : float = 0.0	## objects despawn when reaching this y level


# child
@onready var background = $Background
@onready var basket = $basket
@onready var spawn_line = $SpawnLine
@onready var spawn_timer = $SpawnTimer
@onready var score_label = $ScoreBox/MarginContainer/HBoxContainer/ScoreLabel
@onready var bottom_hitbox = $BottomHitbox


# counters
var current_max_spawn_time : float = 0.0
var elasped_time : float = 0.0


# signals

signal sendAnxietyChange(anxiety: int)
signal endOfGame(minigame : int)


func _ready() -> void:
	randomize()
	
	# setup background dimension reference
	background_start_x = background.global_position.x
	background_end_x = background.global_position.x + background.size.x
	
	# setup despawn y
	despawn_y = bottom_hitbox.global_position.y + 100.0
	
	# setup needed label
	$ScoreBox/MarginContainer/HBoxContainer/NeededLabel.text = str(items_needed)
	
	# setup counters
	current_max_spawn_time = max_spawn_time
	
	# setup timers
	spawn_timer.start(randf_range(min_spawn_time, current_max_spawn_time))


func _process(delta):
	elasped_time += delta
	# update mouse position
	var mouseposition = get_global_mouse_position()
	basket.global_position.x = clamp(mouseposition.x, background_start_x, background_end_x)
	
	# update item position
	for item in get_tree().get_nodes_in_group("Physics"):
		if item.global_position.y >= despawn_y:
			item.queue_free()
		item.velocity = Vector2(0.0, item.gravity)
		item.move_and_slide()
	
	updateDifficulty(elasped_time)


# helpers

## gets an interpolated point from a line2D
## only interpolates between first and last point as a straight line
func getPoint(line : Line2D, weight : float) -> Vector2:
	var point1 = line.get_point_position(0)
	var point2 = line.get_point_position(line.get_point_count() - 1)
	return point1.lerp(point2, clamp(weight, 0.0, 1.0))


## spawns a random item on a random point on the line
func spawnItem():
	if not spawning_items.is_empty():
		var spawn_point = getPoint(spawn_line, randf())
		var spawn_index = randi_range(0, spawning_items.size() - 1)
		var spawn_item : ShelfMinigameItem = spawning_items[spawn_index].duplicate()
		spawn_item.global_position = spawn_point
		spawn_item.rotation = randf_range(0.0, 2 * PI)
		spawn_item.gravity = (gravity + randf_range(-200.0, 200.0)) * gravity_multiplier
		add_child(spawn_item)
		spawn_item.add_to_group("Physics")
	spawn_timer.start(randf_range(min_spawn_time, current_max_spawn_time))


## updates difficulty according to elasped time
func updateDifficulty(elasped_time : float):
	gravity_multiplier = 1.0 + elasped_time / 3
	current_max_spawn_time = clamp(max_spawn_time - elasped_time / 3, min_spawn_time + 0.1, max_spawn_time)


# signals

func _on_spawn_timer_timeout() -> void:
	spawnItem()


func _on_bottom_hitbox_body_entered(body: Node2D) -> void:
	emit_signal("sendAnxietyChange",15)


func _on_basket_hitbox_body_entered(body: Node2D) -> void:
	body.queue_free()
	var current_score = int(score_label.text) + 1
	score_label.text = str(current_score)
	if current_score >= items_needed:
		emit_signal("endOfGame", defs.MINIGAME.SHELF_GAME)
	
