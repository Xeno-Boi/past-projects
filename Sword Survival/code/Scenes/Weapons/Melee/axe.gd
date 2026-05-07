extends Weapons

func _ready():
	._ready()
	type = weapon_type.MELEE.AXE
	attack_type = weapon_type.ATTACK_TYPE.SPIN
