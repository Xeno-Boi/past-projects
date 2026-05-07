extends Weapons

func _ready():
	._ready()
	type = weapon_type.MELEE.HOLY_BLADE
	attack_type = weapon_type.ATTACK_TYPE.BIG_SWEEP
