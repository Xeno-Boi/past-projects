extends Control

# scenes
onready var Player = get_node("/root/Main/Stage/Player")
onready var progress = $TextureProgress
var full_hp

# Called when the node enters the scene tree for the first time.
func _ready():
	progress.value = 100
	full_hp = Player.hp

func take_damage(damage):
	var decrease_amount = float(damage) / float(full_hp) * 100
	progress.value -= decrease_amount

func heal(amount):
	var increase_amount = amount / full_hp * 100
	progress.value += increase_amount
	
func update_total_hp(hp):
	full_hp = hp

func show():
	self.visible = true

func hide():
	self.visible = false
