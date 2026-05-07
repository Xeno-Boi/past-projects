extends Control


func _ready():
	$VBoxContainer/StartButton.grab_focus()


func _on_StartButton_pressed():
	get_tree().change_scene("res://Scenes/Main.tscn")


func _on_OptionsButton_pressed():
	$Panel.visible = !$Panel.visible


func _on_QuitButton_pressed():
	get_tree().quit()
