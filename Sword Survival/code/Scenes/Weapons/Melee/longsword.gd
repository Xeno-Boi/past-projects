extends Weapons

func _ready():
	._ready()
	type = weapon_type.MELEE.LONGSWORD
	attack_type = weapon_type.ATTACK_TYPE.BIG_SWEEP
