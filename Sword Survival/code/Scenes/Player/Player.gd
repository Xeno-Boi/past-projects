extends KinematicBody2D

# scenes
onready var main = get_node("/root/Main")
onready var stage = get_node("/root/Main/Stage")
onready var health_bar = get_node("/root/Main/HUD/HealthBar")

# child
onready var iframe_timer = $Timers/iframe
onready var attack_cooldown_timer = $Timers/Attack_Cooldown
onready var roll_cooldown_timer = $Timers/Roll_Cooldown
onready var weapons_animation = $Weapons_Animation

# weapon types
onready var weapon_type = get_node("/root/Main/Weapon_Type")
var base_weapon = load("res://Scenes/Weapons/Melee/single_handed_sword.tscn")

# movement variables
var acceleration: int
var max_speed: int
var friction: int
var velocity: Vector2 = Vector2.ZERO

# knockback variables
var attacking_mob;
var relative_mob_position: Vector2 = Vector2.ZERO

# stats variable
var agility: int
var knockback: int
var knockback_resistance: int
var hp: int
var defense: int
var damage: int
var attack_speed: int
var max_attack_speed: int = 10	# upon all weapons
var longest_attack_time: float
var roll_colldown_time: float
var iframe_injure: float
var iframe_roll: float

# export stats
export var default_agility: int = 10	# max = 10
export var default_acceleration: int = 30
export var default_max_speed: int = 100
export var default_friction: int = 30
export var default_knockback: int = 3
export var default_knockback_resistance: int = 0
export var default_hp: int = 10
export var default_defense: int = 0
export var default_damage: int = 3
export var default_attack_speed: int = 8	# current weapon, max = 10
export var default_longest_attack_time: float = 1	# longest attack cooldown time, in seconds
export var default_roll_colldown_time: float = 0.3 # in seconds
export var default_iframe_injure: float = 0.4	# in seconds
export var default_iframe_roll: float = 0	# in seconds
export var roll_velocity = 130

# animation players
onready var movementAnimationPlayer = $MovementAnimationPlayer
onready var movementAnimationTree = $MovementAnimationTree
onready var movementAnimationState = movementAnimationTree.get("parameters/playback")

# state
enum STATE_CONST{
	MOVE,
	ATTACK,
	ROLL,
	INJURE,
	DEATH
}

# trackers
var state = STATE_CONST.MOVE
var can_attack: bool = true
var can_roll: bool = true
onready var weapon_holding = $base_weapon
var attack_type = null
var direction_facing: Vector2 = Vector2.ZERO

func _ready():
	reset()

func _physics_process(delta):
	update_movement_stats()
	if Input.is_action_just_pressed("sucide_key"):
		hp = 0
	if hp <= 0:
		state = STATE_CONST.DEATH
		weapons_animation.stop_animation()
	match (state):
		STATE_CONST.MOVE:
			move_state(delta)
		STATE_CONST.ATTACK:
			attack_state(delta)
		STATE_CONST.ROLL:
			roll_state(delta)
		STATE_CONST.INJURE:
			injure_state(delta)
		STATE_CONST.DEATH:
			death_state(delta)
			

func update_movement_stats():
	# movement variables
	var temp_multiplier:float = pow(2, -1 * (1 - float(agility)/10))
	acceleration = default_acceleration * temp_multiplier
	max_speed = default_max_speed * temp_multiplier
	friction = default_friction * temp_multiplier
	# cooldown timer
	roll_colldown_time = default_roll_colldown_time / temp_multiplier


	
func move_state(delta):
	$Sprite.self_modulate = Color(1,1,1,1)
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vector.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		# update velocity
		velocity = velocity.move_toward(input_vector * max_speed, acceleration)
		# update animation direction
		movementAnimationTree.set("parameters/Idle/blend_position", input_vector)
		movementAnimationTree.set("parameters/Run/blend_position", input_vector)
		# go to run animation
		movementAnimationState.travel("Run")
	else:
		# update velocity
		velocity = velocity.move_toward(Vector2.ZERO, friction)
		# go to idle animation
		movementAnimationState.travel("Idle")
	
	direction_facing = movementAnimationTree.get("parameters/Idle/blend_position")
	velocity = move_and_slide(velocity)
	
	# set attack direction as mouse direction
	if Input.is_action_pressed("attack") and can_attack:
		movementAnimationTree.set("parameters/" + attack_type + "/blend_position", get_local_mouse_position().normalized())
		weapons_animation.set_direction(weapon_holding, get_local_mouse_position().normalized())
		# set correct attack type
		direction_facing = movementAnimationTree.get("parameters/" + attack_type + "/blend_position")
		state = STATE_CONST.ATTACK
		start_attack_cooldown()
	
	if Input.is_action_pressed("roll"):
		if (can_roll):
			# set roll direction to direction player facing
			input_vector = movementAnimationTree.get("parameters/Idle/blend_position")
			movementAnimationTree.set("parameters/Roll/blend_position", input_vector)
			velocity = input_vector * roll_velocity
			state = STATE_CONST.ROLL
			start_iframe()
			start_roll_cooldown()
	

func attack_state(delta):
	movementAnimationState.travel(attack_type)
	weapons_animation.attack(weapon_holding)

func attack_animation_finished():
	state = STATE_CONST.MOVE
	velocity = Vector2.ZERO


# roll state

func roll_state(delta):
	movementAnimationState.travel("Roll")
	move_and_slide(velocity)

func roll_animation_finish():
	state = STATE_CONST.MOVE
	movementAnimationState.travel("Idle")


# injure state

func injure_state(delta):
	movementAnimationState.travel("Injure")
	# move
	move_and_slide(velocity)

func injure_animation_finished():
	velocity = Vector2.ZERO
	state = STATE_CONST.MOVE

func _on_Hurtbox_area_entered(area):
	if defense != 0:
		weapon_holding.defend()
	weapons_animation.stop_animation()
	$PlayerdamagedSound.play()
	$Sprite.self_modulate = Color(1,0.33,0.33,1)
	attacking_mob = area.get_parent()
	# get opposite direction to attacking mob
	relative_mob_position = (attacking_mob.position - self.global_position) * -1
	# get knockback multiplyer
	var knockback_multiplier = attacking_mob.knockback - knockback_resistance
	# get knockback velocity
	velocity = relative_mob_position.normalized() * knockback_multiplier * 20
	movementAnimationTree.set("parameters/Injure/blend_position", relative_mob_position * -1)
	direction_facing = movementAnimationTree.get("parameters/Injure/blend_position")
	state = STATE_CONST.INJURE
	take_damage(attacking_mob.damage)
	start_iframe()
	# stop attack cooldown
	attack_cooldown_timer.stop()
	can_attack = true
	# stop roll cooldown
	roll_cooldown_timer.stop()
	can_roll = true
	
func take_damage(damage):
	# prevent damage drop below 0
	var amount = max(damage - defense, 0)
	hp -= amount
	health_bar.take_damage(amount)


# death state

func death_state(delta):
	if !$gameOver.is_playing():
		$gameOver.play()
	velocity = Vector2.ZERO
	movementAnimationState.travel("Death")

	
func death_animation_finish():
	$gameOver.stop()
	# make this longer later?
	get_tree().change_scene("res://Scenes/Menus/DeathMenu.tscn")


func disable_collision():
	$Weapons_Animation/Hitbox.set_deferred("monitorable", false)
	$Hurtbox.set_deferred("monitoring", false)
	$Weapons_Animation/Hitbox/HitboxCollision.set_deferred("disabled", true)
	$Hurtbox/HurtboxCollision.set_deferred("disabled", true)

func enable_collision():
	$Weapons_Animation/Hitbox.monitorable = true
	$Hurtbox.monitoring = true
	$Hurtbox/HurtboxCollision.disabled = false


# starts iframe timer depending on type
func start_iframe():
	disable_collision()
	match(state):
		STATE_CONST.INJURE:
			iframe_timer.start(iframe_injure)
		STATE_CONST.ROLL:
			iframe_timer.start(iframe_roll)
	

func _on_iframe_timeout():
	$Sprite.self_modulate = Color(1,1,1,1)
	match(state):
		STATE_CONST.INJURE:
			injure_animation_finished()
		STATE_CONST.ROLL:
			pass
	enable_collision()


# blocks player attack
func start_attack_cooldown():
	can_attack = false
	var cooldown = float(longest_attack_time) * float(max_attack_speed - attack_speed)/float(max_attack_speed)
	cooldown = max(0.05, cooldown)
	attack_cooldown_timer.wait_time = cooldown
	attack_cooldown_timer.start()

func _on_Attack_Cooldown_timeout():
	can_attack = true


# blocks player roll
func start_roll_cooldown():
	can_roll = false
	roll_cooldown_timer.wait_time = roll_colldown_time
	roll_cooldown_timer.start()

func _on_Roll_Cooldown_timeout():
	can_roll = true
	

# update holding weapon, holds the weapon scene so that stat of the weapon can be used
func update_weapon_holding(weapon):
	weapon_holding.queue_free()
	self.add_child(weapon)
	weapon_holding = weapon
	agility = weapon.agility
	knockback = weapon.knockback
	damage = weapon.damage
	defense = weapon.defense
	attack_speed = weapon.attack_speed
	attack_type = weapon_type.ATTACK_TYPE.keys()[weapon_holding.attack_type]

func weapon_break():
	$WeaponBreak.play()
	update_weapon_holding(base_weapon.instance())
	weapon_holding.status = weapon_holding.STATUS.ON_HAND
	weapon_holding.update_weaponsHUD()

func reset():
	velocity = Vector2.ZERO
	movementAnimationState.travel("Idle")
	global_position = (Vector2(118,68))
	movementAnimationTree.set("parameters/Idle/blend_position", Vector2.RIGHT)
	movementAnimationTree.set("parameters/Run/blend_position", Vector2.RIGHT)
	var state = STATE_CONST.MOVE
	var can_attack = true
	var can_roll = true
	attack_cooldown_timer.stop()
	roll_cooldown_timer.stop()
	iframe_timer.stop()
	# stats
	knockback_resistance = default_knockback_resistance
	hp = default_hp
	defense = default_defense
	longest_attack_time = default_longest_attack_time
	iframe_injure = default_iframe_injure
	iframe_roll = default_iframe_roll
	relative_mob_position = Vector2.ZERO
	# hold base weapon
	yield(main, "ready")
	weapon_holding.status = weapon_holding.STATUS.ON_HAND
	agility = weapon_holding.agility
	knockback = weapon_holding.knockback
	damage = weapon_holding.damage
	attack_speed = weapon_holding.attack_speed
	attack_type = weapon_type.ATTACK_TYPE.keys()[weapon_holding.attack_type]
	weapon_holding.update_weaponsHUD()


func _on_Weapons_Animation_mob_hit():
	weapon_holding.mob_hit()
