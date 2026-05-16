extends Control

const defs = preload("res://scripts/defs.gd")

# signal

signal changeScene(scene_type)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$MenuContainer/TaskButton.pressed.connect(_on_TaskButton_pressed)
	$MenuContainer/WorkBenchButton.pressed.connect(_on_WorkBenchButton_pressed)
	$MenuContainer/ExitButton.pressed.connect(_on_ExitButton_pressed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	update_current_money()
	update_current_budget()
	
func update_current_money():
	var label = $MenuContainer/BalanceLabel
	label.text = "Money: $%d" % [inventory.current_money]
	
func _on_TaskButton_pressed():
	emit_signal("changeScene", defs.SCENE.TASK)
	
func _on_WorkBenchButton_pressed():
	emit_signal("changeScene", defs.SCENE.WORKBENCH)
	
func _on_ExitButton_pressed():
	get_tree().quit()

func update_current_budget():
	var label = $MenuContainer/BudgetLabel
	if inventory.current_task == null:
		label.hide()
	else:
		label.show()
		label.text = "Current Budget: $%d" % [inventory.current_task.reward]
