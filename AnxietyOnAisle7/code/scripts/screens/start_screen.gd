extends Node2D

'''
Functions for the staring screen
'''


# signals
signal startGame()


func _on_start_button_pressed() -> void:
	emit_signal("startGame")


func _on_fake_start_button_pressed() -> void:
	$IntroScreen.show()
	$InitialScreen.hide()
