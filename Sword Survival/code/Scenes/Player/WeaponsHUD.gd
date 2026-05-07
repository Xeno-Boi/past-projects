extends CanvasLayer

onready var weapon_durability = $weaponDurability

func _ready():
	$WeaponImage.texture = $BaseSword.texture

# called from Weapons.gd inside pickup()
func on_weapon_swap(weaponAnimatedSprite, durability):
	$WeaponImage.texture = weaponAnimatedSprite.get_sprite_frames().get_frame("default", weaponAnimatedSprite.get_frame()) 
	weapon_durability.new_weapon(durability)
	# add something similar for arrows
	# use numbers to keep track of how many
	# use .hide() to hide text when using sword

func reduce_durability(amount):
	weapon_durability.reduce_durability(amount)

func on_shoot():
	pass
	# update numbers for arrows here
	
#func on_update_durability():
#	tempDurability-=1
#	$DurabilityBar.value = tempDurability
#	# set to actual weapon durability here
#
## get rid of this when durability implemented
#func _process(delta):
#	on_update_durability()
	
# canvaslayer doesn't have visible property this so use the following instead
# used so that minimap doesn't show hud
func hide():
	for N in self.get_children():
		N.hide()
