extends CanvasLayer

'''
main ui scene
'''


# child
@export var anxiety_bar: ProgressBar
@onready var to_do_list = $ToDoList
@onready var breathing_icon = $icon_tray/breathing_icon
var tween : Tween	# for smooth movement between values
@onready var anxiety_bar_shader = $MarginContainer/VBoxContainer/ShaderContainer

# Breathing Warning
@onready var breathing_warning = $BreathingWarning


# counters
var notebook_icon_mouse_inside : bool = false
var breathing_icon_mouse_inside : bool = false


# signal
signal anxietyBarFull()
signal loadBreathingGame()


func _ready() -> void:
	breathing_icon.max_value = defs.breathing_game_cooldown


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("mouse_click"):
		if notebook_icon_mouse_inside:
			to_do_list.toggleList()
		elif breathing_icon_mouse_inside:
			emit_signal("loadBreathingGame")


func _process(delta: float) -> void:
	if anxiety_bar.value >= anxiety_bar.max_value:
		anxiety_bar.value = 0
		emit_signal("anxietyBarFull")
	AnxietyCounter.smooth_anxiety = anxiety_bar.value
	var shader_material = anxiety_bar_shader.material
	shader_material.set_shader_parameter("anxiety", AnxietyCounter.smooth_anxiety)


# functions

# anxiety bar setters

## initializes the anxiety bar
func initializeAnxietyBar(max_value, current_value):
	setAnxietyBarMaxValue(max_value)
	updateAnxietyBarValue(current_value)

## sets the max value of the anxiety bar
func setAnxietyBarMaxValue(new_value : float):
	anxiety_bar.max_value = new_value


## updates the current value of the anxiety bar
func updateAnxietyBarValue(new_value : float):
	# smoothly move to new value
	if tween and tween.is_running():
		tween.kill()
	tween = create_tween()
	tween.tween_property(anxiety_bar, "value", new_value, 1.0)


func toggleBreathingWarning():
	if AnxietyCounter.current_anxiety >= 500 and\
		not get_tree().has_group("minigame"):
		breathing_warning.show()
	else:
		breathing_warning.hide()

	
##hide breathing minigame instructions
func hideBreathingWarning():	
	breathing_warning.hide()
	
	
## toggles icon visibility
func toggleIcon(show : bool):
	if show:
		$icon_tray.show()
	else:
		$icon_tray.hide()


## updates breathing icon value
func updateBreathingIcon():
	breathing_icon.value = clampf(defs.breathing_game_cooldown - defs.breathing_game_timer, 0.0, INF)


func _on_notebook_icon_mouse_entered() -> void:
	notebook_icon_mouse_inside = true


func _on_notebook_icon_mouse_exited() -> void:
	notebook_icon_mouse_inside = false


func _on_breathing_icon_mouse_entered() -> void:
	breathing_icon_mouse_inside = true


func _on_breathing_icon_mouse_exited() -> void:
	breathing_icon_mouse_inside = false
