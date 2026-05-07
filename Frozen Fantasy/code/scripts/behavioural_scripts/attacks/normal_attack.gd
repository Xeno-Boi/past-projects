extends TargetedAttack
class_name NormalAttack

func attack(attacker: DynamicObj) -> bool:
	if (!super.attack(attacker)): return false
	attacker.targetObject.takeDamage(attackDamage, attacker)
	
	playParticles()
	
	return true
