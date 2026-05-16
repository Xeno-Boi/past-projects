extends SelectableObject

# signal
signal winGame()


## condition for the selectable to be activated [br]
## overwrite in needed class
func activateCondition() -> bool:
	return defs.allTaskComplete()
	
	
## should not be able to select
func selectAction():
	pass


# signal

func _on_exit_body_entered(body: Node2D) -> void:
	if active:
		emit_signal("winGame")
	else:
		var to_do_list = get_tree().root.get_node("Main").to_do_list
		to_do_list.showList()
		print("tasks incomplete")
