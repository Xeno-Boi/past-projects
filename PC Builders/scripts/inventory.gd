extends Node

var current_money = 0
var active_tasks: Array[TaskData] = []
var current_task: TaskData = null
var task_buttons = {}
	
func add_task(task):
	active_tasks.append(task)
	
func accept_task(task):
	if task in active_tasks:
		current_task = task
		active_tasks.erase(task)
		if task in task_buttons:
			var button = task_buttons[task]
			if button and is_instance_valid(button):
				button.queue_free()
			task_buttons.erase(task)

func reject_task(task):
	if task in active_tasks:
		active_tasks.erase(task)
		if task in task_buttons:
			var button = task_buttons[task]
			if button and is_instance_valid(button):
				button.queue_free()
			task_buttons.erase(task)
