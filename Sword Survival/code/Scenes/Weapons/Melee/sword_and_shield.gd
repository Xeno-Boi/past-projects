extends Weapons

func _ready():
	._ready()
	type = weapon_type.MELEE.SWORD_AND_SHIELD
	attack_type = weapon_type.ATTACK_TYPE.SWEEP
