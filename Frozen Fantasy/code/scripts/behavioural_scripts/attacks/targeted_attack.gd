extends AttackType
class_name TargetedAttack

func attack(attacker : DynamicObj) ->bool: 
	if (!super.attack(attacker)): return false
	#prevent attacks not on untis or buildings
	if(attacker.targetObject == null or not (attacker.targetObject is DynamicObj or attacker.targetObject is BuildingObj)):
		return false
	
	#attacks only work on targets in range.
	if ((attacker.global_position - attacker.targetObject.global_position).length() > attackRange):
		return false
	
	return true
