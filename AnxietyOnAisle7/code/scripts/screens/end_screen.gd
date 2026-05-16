extends Node2D

'''
Functions for the staring screen
'''


# child
@onready var win_screen = $WinScreen
@onready var lose_screen = $LoseScreen

# signals
signal restartGame()


## sets up end screen [br]
## adjusts according to game_won
func setup(game_won : bool) -> void:
	if game_won:
		win_screen.show()
		lose_screen.hide()
	else:
		lose_screen.show()
		win_screen.hide()


# signals

func _on_restart_button_pressed() -> void:
	emit_signal("restartGame")
