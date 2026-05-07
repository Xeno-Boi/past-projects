extends Sprite

# scene
onready var player = get_node("/root/Main/Stage/Player")

func _ready():
	self.global_position = player.position

func _process(delta):
	self.global_position = player.position
	self.look_at(self.global_position + player.direction_facing)
