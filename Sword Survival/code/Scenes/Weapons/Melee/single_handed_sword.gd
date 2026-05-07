extends Weapons

func _ready():
	._ready()
	type = weapon_type.MELEE.SINGLE_HANDED_SWORD
	attack_type = weapon_type.ATTACK_TYPE.SWEEP
