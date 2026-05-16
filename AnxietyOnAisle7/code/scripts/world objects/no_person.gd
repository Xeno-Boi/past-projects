extends StaticBody2D


'''
class for npc
'''

# properties
@export var scripts : npc_scripts
@export var face_direction : Vector2 = Vector2(0.0, -1.0)	## 2d direction npc is facing
@export var script_gradient : Gradient
@export var script_time : float = 5.0	## time the script will be shown for, in seconds
@export var max_between_script_time : float = 5.0	## max amount of time between each script, in seconds
@export var load_script_speed : float = 1.0	## time needed to completely write script to label, in seconds

# child
@onready var animation_tree = $AnimationTree
@onready var animation_state = animation_tree.get("parameters/playback")
@onready var script_label = $ScriptLabel
@onready var script_timer = $ScriptTimer	# timer for displaying a script
var script_loader_tween : Tween


# counters
var player_entered : bool = false
var between_script_timer : float = 0.0


func _ready() -> void:
	# set direction
	face_direction = face_direction.normalized()
	face(face_direction)
	
	# set timer
	randomize()
	between_script_timer = randf_range(0.0, max_between_script_time) / 4
	script_timer.wait_time = script_time
	
	# set script label
	script_label.hide()


func _process(delta: float) -> void:
	# script timer
	if player_entered:
		between_script_timer -= delta
		
	if between_script_timer <= 0.0:
		if not script_label.visible:	# no script yet
			loadScript()


# helpers
## set face direction of npc
## sets animation tree blend position
func face(direction : Vector2):
	animation_tree.set("parameters/Idle/blend_position", direction)
	animation_tree.set("parameters/Run/blend_position", direction)


## loads a script into text label and sets display timer
func loadScript():
	script_label.visible_ratio = 0.0
	script_label.text = scripts.getScript(AnxietyCounter.current_anxiety)
	var script_color = script_gradient.sample(scripts.getWeight(AnxietyCounter.current_anxiety))
	script_label.set("theme_override_colors/font_color", script_color)
	script_label.show()
	# type writer effect for script label
	script_loader_tween = create_tween()
	script_loader_tween.tween_property(script_label, "visible_ratio", 1.0, load_script_speed)
	script_loader_tween.tween_callback(_on_script_loader_tween_finished)


# signals

func _on_player_detector_body_entered(body: Node2D) -> void:
	player_entered = true


func _on_player_detector_body_exited(body: Node2D) -> void:
	player_entered = false


func _on_script_timer_timeout() -> void:
	script_label.text = ""
	script_label.hide()
	between_script_timer = randf_range(0.0, max_between_script_time)


func _on_script_loader_tween_finished():
	script_timer.start()
