extends Node
class_name AttackType

@export var attackDamage : float = 0
@export var attackRange : float = 1
#optional particles on attack
@export var attackParticleEffect : GPUParticles3D = null

"""
Functionality:
	provides classes for a variety of attacks
	Customizable damage, range, area attacks, etc.
	
"""


func attack(attacker: DynamicObj) ->bool:
	#general attack behaviour, if any
	if(not is_instance_valid(attacker) or not is_instance_valid(attacker.targetObject)):
		return false
	
	if OS.is_debug_build() and attacker.targetObject != null: print(attacker.name, " attacks ", attacker.targetObject.name, " for ", attackDamage)
	
	return true


func playParticles() -> void:
	if(attackParticleEffect != null):
		attackParticleEffect.emitting = true
	
