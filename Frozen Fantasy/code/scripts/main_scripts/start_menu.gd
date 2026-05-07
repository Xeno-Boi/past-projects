extends Control

var defs = preload("res://defs.gd")

@onready var start_button = $OptionBorder/OptionButtons/StartButton
@onready var quit_button = $OptionBorder/OptionButtons/QuitButton
@onready var progress_bar = $ProgressBar
@onready var loading_label = $LoadingLabel

const SCENE_PATH = "res://scenes/main.tscn"

var loaded_scene : PackedScene
var load_finished = false
var start_pressed = false
var fake_progress = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_button.pressed.connect(on_start_pressed)
	quit_button.pressed.connect(on_quit_pressed)
	progress_bar.visible = false
	loading_label.visible = false
	progress_bar.value = 0
	$OptionBorder.size = $OptionBorder/OptionButtons.size + Vector2(6, 20.0)
	
	WorkerThreadPool.add_task(load_scene_threaded, false, "SceneLoader")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if start_pressed:
		if load_finished:
			if fake_progress >= 95:
				progress_bar.value = 100
				loading_label.text = "Loading Complete! Entering the game..."
				start_game()
			else:
				fake_progress += delta * 200
				progress_bar.value = fake_progress
		else:
			if fake_progress < 95:
				fake_progress += delta * 100
				progress_bar.value = fake_progress
			else:
				progress_bar.value = 95
		
			
	
func load_scene_threaded():
	var scene = ResourceLoader.load(SCENE_PATH)
	if scene:
		call_deferred("on_scene_loaded", scene)

func on_scene_loaded(scene):
	loaded_scene = scene
	load_finished = true
	

func on_start_pressed():
	start_pressed = true
	start_button.disabled = true
	progress_bar.visible = true
	loading_label.visible = true
	print("Start pressed, but still loading...")
	
func start_game():
	print("Switch to main scene")
	get_tree().change_scene_to_packed(loaded_scene)

func on_quit_pressed():
	get_tree().quit()
