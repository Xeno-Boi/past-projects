extends Control


# property
var show_position : Vector2	## on screen position
var hide_position : Vector2	## off screen position


# counter
var task_item : Dictionary[int, Node] = {}	## keeps track of what task corresponds to which item in list
var showing : bool = true	## if the list is on screen or not
var mouse_inside : bool = false	## keeps tracks of if the mouse is inside


# child
@onready var todo_label = $NinePatchRect/VBoxContainer/ToDoLabel
@onready var task_item_container = $NinePatchRect/VBoxContainer/ScrollContainer/TaskItemContainer
var tween : Tween
@onready var show_timer = $ShowTimer


# data
var task_description = {
	defs.TASKS.CHECKOUT: "Get all the items and head to check out.",
	defs.TASKS.SIBLING: "Find your missing sibling."
}


func _ready() -> void:
	show_position = global_position
	hide_position = global_position
	hide_position.x += 500
	hideList()


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("to_do_list_toggle"):
		if showing:
			hideList()
		else:
			showList()
	if Input.is_action_just_pressed("mouse_click"):
		if mouse_inside:
			hideList()


## shows to do list
func showList():
	if not showing:
		showing = true
		if tween and tween.is_running():
			tween.kill()
		tween = create_tween()
		tween.tween_property(self, "global_position", show_position, 0.1)
		tween.tween_callback(_on_show_tween_finished)


## hides to do list
func hideList():
	if showing:
		showing = false
		if tween and tween.is_running():
			tween.kill()
		tween = create_tween()
		tween.tween_property(self, "global_position", hide_position, 0.1)
		show_timer.stop()


## toggles list
func toggleList():
	if showing:
		showing = false
		if tween and tween.is_running():
			tween.kill()
		tween = create_tween()
		tween.tween_property(self, "global_position", hide_position, 0.1)
		show_timer.stop()
	else:
		showing = true
		if tween and tween.is_running():
			tween.kill()
		tween = create_tween()
		tween.tween_property(self, "global_position", show_position, 0.1)
		tween.tween_callback(_on_show_tween_finished)

# helpers
## clears all task items on list
func clearList():
	for item in task_item_container.get_children():
		item.queue_free()
	task_item = {}


## removes specific item on list
func removeItem(task : int):
	if task in task_item.keys():
		task_item[task].queue_free()
		task_item.erase(task)


## adds a  task to list
func addItem(task : int):
	if task in task_description.keys():
		removeItem(task)
		var new_label = todo_label.duplicate()
		new_label.text = task_description[task]
		new_label.set("theme_override_font_sizes/font_size", 20)
		task_item_container.add_child(new_label)
		task_item[task] = new_label


# signals

func _on_show_tween_finished():
	show_timer.start()


func _on_show_timer_timeout() -> void:
	hideList()


func _on_mouse_entered() -> void:
	mouse_inside = true


func _on_mouse_exited() -> void:
	mouse_inside = false
