extends TargetedAttack
class_name RecruitingAttack

@export var newAS : Script = null

func attack(attacker: DynamicObj) ->bool:
	if (!super.attack(attacker)): return false
	#avoid subbing in nonexistant actionSet
	if(newAS == null): return false
	
	#make sure attacker is unit of opposite alignment
	if(attacker.targetObject is DynamicObj and attacker.targetObject.alignment != attacker.alignment):
		attacker.targetObject.changeActionSet(newAS.new())
		
		playParticles()
		return true
	return false
