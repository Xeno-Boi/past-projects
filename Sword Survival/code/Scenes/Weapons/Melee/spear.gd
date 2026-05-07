extends Weapons

func _ready():
	._ready()
	type = weapon_type.MELEE.SPEAR
	attack_type = weapon_type.ATTACK_TYPE.PIERCE
