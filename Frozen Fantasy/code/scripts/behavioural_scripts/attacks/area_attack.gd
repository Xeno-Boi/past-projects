extends AttackType
class_name AreaAttack

@export var attackArea : Area3D = null


func _ready() ->void:
	#make sure attack area isn't clickable
	attackArea.input_ray_pickable = false	
	
func attack(attacker: DynamicObj) -> bool:
	if (!super.attack(attacker)): return false
	
	for enemy in attacker.findEnemiesInArea(attackArea):
		enemy.takeDamage(attackDamage, attacker)	
	
	playParticles()
	
	return true
