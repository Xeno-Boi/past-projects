extends Node2D

const defs = preload("res://scripts/defs.gd")

# scenes
var scenes	# stores loaded scenes
var active_scene = null	# stores current active scene


func _ready() -> void:
	$UI/Menu.changeScene.connect(switchToScene)
	$Scenes/WorkBench.turnInComputer.connect($Scenes/Task._on_turn_in_PC)
	scenes = {
		defs.SCENE.TASK: $Scenes/Task,
		defs.SCENE.WORKBENCH: $Scenes/WorkBench,	
		}
		
	# disables all scenes
	for scene in scenes.values():
		scene.hide()
		scene.get_node("Background").hide()
		scene.position = Vector2(99999.9, 99999.9)
	# opens workbench scene at start
	switchToScene(defs.SCENE.TASK)


# sends input to active scene
func _input(event):
	if active_scene == scenes[defs.SCENE.WORKBENCH]:
		active_scene.input(event)


# changes scene without reloading
# if scene not already loaded, creates scene
func switchToScene(scene_type):
	if active_scene:	# a scene is currently active
		# stops scene updates
		active_scene.hide()
		active_scene.get_node("Background").hide()
		active_scene.position = Vector2(99999.9, 99999.9)
	# set to new scene
	active_scene = scenes[scene_type]
	active_scene.show()
	active_scene.get_node("Background").show()
	active_scene.position = Vector2(0.0, 0.0)


# signals

func _on_task_task_complete_result(success: bool) -> void:
	$Scenes/WorkBench._on_turn_in_result(success)
	switchToScene(defs.SCENE.TASK)
