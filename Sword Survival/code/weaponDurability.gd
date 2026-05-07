extends Control

# scene
onready var player = get_node("/root/Main/Stage/Player")

# child
onready var progress_bar = $TextureProgress

# trackers
var unbreakable: bool = true


func _process(delta):
	if progress_bar.value <= 0:
		if (!unbreakable):
			player.weapon_break()


func new_weapon(max_dur):
	progress_bar.max_value = max_dur
	progress_bar.value = max_dur
	if max_dur == -1:
		unbreakable = true
	else:
		unbreakable = false


func reduce_durability(amount):
	progress_bar.value -= amount
