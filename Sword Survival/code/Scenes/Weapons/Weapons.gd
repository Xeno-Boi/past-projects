extends Node2D

class_name Weapons

var weaponKey

# scene
onready var Main = get_node("/root/Main")
onready var Player = get_node("/root/Main/Stage/Player")
onready var WeaponsHUD = get_node("/root/Main/HUD/WeaponsHUD")

# child
onready var despawnTimer = $despawnTimer
onready var animatedSprite = $AnimatedSprite

# weapon type
onready var weapon_type = get_node("/root/Main/Weapon_Type")

# stats
var type
var attack_type # MELEE etc
export var agility: int	# max = 10
export var knockback: int
export var damage: int
export var attack_speed: int
export var defense: int
export var spawn_weight: int # likehood to spawn compared to other weapons in same category
var despawnTime: int
export var durability: int = 100 # 0-10
export var despawnable: bool = true

# status
enum STATUS{
	ON_GROUND,
	ON_HAND,
}

# trackers
export var status = STATUS.ON_HAND;

func _ready():
	animatedSprite.playing = true
	$Label.visible = false
	animatedSprite.animation = "default"
	if status == STATUS.ON_GROUND and despawnable:
		despawnTime = Main.weapon_despawn_time
		despawnTimer.wait_time = despawnTime
		despawnTimer.start()
		
func _process(delta):
	match (status):
		STATUS.ON_HAND:
			despawnTimer.stop()
			visible = false
			$CollisionShape2D.set_deferred("monitorable", false)
			$CollisionShape2D.set_deferred("monitoring", false)
		STATUS.ON_GROUND:
			visible = true
			$CollisionShape2D.set_deferred("monitorable", true)
			$CollisionShape2D.set_deferred("monitoring", true)
	

func pickup():
	despawnTimer.stop()
	update_weaponsHUD()
	# reparent to player
	status = STATUS.ON_HAND
	self.get_parent().remove_child(self)
	Player.update_weapon_holding(self)


func update_weaponsHUD():
	WeaponsHUD.on_weapon_swap(animatedSprite, durability)  # connect to WeaponsHUD

func mob_hit():
	WeaponsHUD.reduce_durability(1)

func defend():
	WeaponsHUD.reduce_durability(2)

func _on_despawnTimer_timeout():
	queue_free()

func highlight():
	animatedSprite.animation = "highlight"
	$Label.visible = true
	
func remove_highlight():
	animatedSprite.animation = "default"
	$Label.visible = false
	
