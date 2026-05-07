extends Weapons

func _ready():
	._ready()
	type = weapon_type.MELEE.GREATSWORD
	attack_type = weapon_type.ATTACK_TYPE.SWEEP
