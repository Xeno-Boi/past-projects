extends Control

# scenes
onready var tree = get_tree()

func _ready():
	$Results/Time.text = String(ScoreSheet.time_survived)
	$Results/Score.text = String(ScoreSheet.score)


func _on_PlayAgain_pressed():
	tree.change_scene("res://Scenes/Main.tscn")


func _on_Quit_pressed():
	tree.quit()
