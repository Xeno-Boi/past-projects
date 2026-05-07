extends KinematicBody2D

class_name Mobs

# scenes
onready var player = get_node("/root/Main/Stage/Player")
onready var stage = get_node("/root/Main/Stage")
onready var map = get_node("/root/Main/Map")
onready var main = get_node("/root/Main")
onready var score_hud = get_node("/root/Main/HUD/ScoreHUD")

# child
onready var detection = $Detection
onready var detect_area = $Detection/Detect_Area
onready var attack_area = $Detection/Attack_Area
onready var forget_timer = $Timer/Forget_timer
onready var soft_collision = $SoftCollision
onready var weapon_spawner = $WeaponSpawner
onready var wander_controller = $WanderController
onready var onscreen_checker = $Onscreen_checker
onready var hitSound = $hitSound
onready var despawn_timer = $Timer/Despawn_timer
onready var injure_timer = $Timer/Injure_timer
onready var alert_icon = $alert_icon

# movement variables
export var acceleration: int = 20
export var max_speed: int = 10
export var friction: int = 20
export var knockback_friction: int = 2
var velocity: Vector2 = Vector2.ZERO
var relative_player_position: Vector2 = Vector2.ZERO
var path: Array = []

# stat
export var knockback: int = 0
export var knockback_resistance: int = 0
export var hp: int = 0
export var damage: int = 0
export var defense: int = 0
export var attack_cooldown: float = 0 # in seconds
export var forget_time: int = 0 # in seconds
export var spawn_weight: int = 0 # likelyhood of spawning relative to other mobs
export var wander_timerange_start: int = 1	# timerange for mob to choose between wander and idle
export var wander_timerange_end: int = 5

# animation players
onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")

# rng
var rng = RandomNumberGenerator.new()

# state
enum {
	IDLE,
	WANDER,
	CHASE,
	ATTACK,
	INJURE,
	DEATH
}

# trackers
var state = IDLE
#var batch_state = null	# batch current state if an animation is playing
var can_see_player: bool = false
onready var wander_target_position: Vector2 = global_position

func _ready():
	rng.randomize()

func _physics_process(delta):
	if can_see_player:
		alert_icon.show()
	else:
		alert_icon.hide()
	if hp <= 0 and despawn_timer.is_stopped():
		state = DEATH
		despawn_timer.start()
	match (state):
		IDLE:
			idle_state(delta)
		WANDER:
			wander_state(delta)
		CHASE:
			chase_state(delta)
		ATTACK:
			attack_state(delta)
		INJURE:
			injure_state(delta)
		DEATH:
			death_state(delta)

func _on_Detect_Area_body_entered(body):
	forget_timer.stop()
	can_see_player = true
	detect_area.get_child(0).scale = Vector2(2,2)
	
func _on_Detect_Area_body_exited(body):
	forget_timer.start(forget_time)
	detect_area.get_child(0).scale = Vector2(1,1)
	
func _on_Attack_Area_body_entered(body):
	if (![DEATH, INJURE].has(state)):
		state = ATTACK
		
func _on_Forget_timer_timeout():
	can_see_player = false


# idle state

func idle_state(delta):
	if hp <= 0 and despawn_timer.is_stopped():
		state = DEATH
		despawn_timer.start()
	update_look_direction(Vector2.RIGHT.rotated(deg2rad(detection.rotation_degrees)))
	if onscreen_checker.is_on_screen():
		if can_see_player:
			state = CHASE
		velocity = velocity.move_toward(Vector2.ZERO, friction)
		animationState.travel("Idle")
		if wander_controller.get_time_left() == 0:
			reset_wander_controller()


func pick_random_state(state_list):
	state_list.shuffle()
	match(state):
		IDLE:
			state = state_list.pop_front()
			if state == WANDER:
				main.start_wander()
		WANDER:
			state = state_list.pop_front()
			if state == IDLE:
				main.stop_wandering()


# wander state

func wander_state(delta):
	if hp <= 0 and despawn_timer.is_stopped():
		state = DEATH
		despawn_timer.start()
	if can_see_player:
		main.stop_wandering()
		state = CHASE
	# arrived near target
	if self.global_position.distance_to(wander_target_position) <= 3:
		state = IDLE
		main.stop_wandering()
		reset_wander_controller()
	# find path to target
	path = map.get_simple_path(self.global_position, wander_target_position)
	move_along_path(delta, null)
	
	if wander_controller.get_time_left() == 0:
		reset_wander_controller()

func reset_wander_controller():
	if main.can_wander():
		wander_target_position = wander_controller.get_new_target()
		pick_random_state([IDLE, WANDER])
		wander_controller.start_timer(rng.randf_range(wander_timerange_start, wander_timerange_end))

# chase state

func chase_state(delta):
	if hp <= 0 and despawn_timer.is_stopped():
		state = DEATH
		despawn_timer.start()
	if !can_see_player:
		state = IDLE
	path = map.get_simple_path(self.global_position, player.position)
	move_along_path(delta, player.position)

func move_along_path(delta, look_direction): # set look_direction to null for mob to look at direction it's going
	if !path.empty():
		velocity = global_position.direction_to(path[1]) * max_speed
		
		if look_direction != null:
			detection.look_at(look_direction)
		else:
			detection.look_at(path[1])
					
		if global_position.distance_to(path[0]) <= 50:
			path.pop_front()

		update_look_direction(Vector2.RIGHT.rotated(deg2rad(detection.rotation_degrees)))
		
		animationState.travel("Run")
		velocity = move_and_slide(velocity)

func update_look_direction(direction):
	animationTree.set("parameters/Idle/blend_position", direction)
	animationTree.set("parameters/Run/blend_position", direction)

# attack state

func attack_state(delta):
	if hp <= 0 and despawn_timer.is_stopped():
		state = DEATH
		despawn_timer.start()
	animationState.travel("Attack")
	
func attack_animation_finished():
	yield(get_tree().create_timer(attack_cooldown), "timeout")
	velocity = Vector2.ZERO
	if (state == ATTACK):	# player havent leave detection zone
		if (attack_area.get_overlapping_bodies().empty()):	# player left attack zone
			state = CHASE
	else:
		forget_timer.start(forget_time)
		detect_area.get_child(0).scale = Vector2(1,1)
	
	
# injure state

func injure_state(delta):
	if hp <= 0 and despawn_timer.is_stopped():
		state = DEATH
		despawn_timer.start()
	animationState.travel("Injure")	
	# move
	move_and_slide(velocity)
	velocity = velocity.move_toward(Vector2.ZERO, knockback_friction)

func injure_animation_finished():
	injure_timer.stop()
	hitSound.stop()
	state = IDLE
	enable_collision()

func _on_Hurtbox_area_entered(area):
	injure_timer.start()
	hitSound.play()
	if (can_see_player):
		hp -= player.damage
	else:	# backstab bonus
		hp -= player.damage * 1.5
	animationTree.set("parameters/Injure/blend_position", (player.position - self.global_position).normalized())
	if state != CHASE:
		# look at attack direction
		detection.look_at(player.position)
		update_look_direction(self.global_position.direction_to(player.position))
	state = INJURE
	# get knockback multiplyer
	var knockback_multiplier = player.knockback - knockback_resistance
	# get knockback velocity
	var relative_player_position = player.position - self.global_position
	velocity = (relative_player_position.normalized() * -1) * knockback_multiplier * 20
	disable_collision()

# in case mob stuck in injure state
func _on_Injure_timer_timeout():
	injure_animation_finished()
	

# death state
	
func death_state(delta):
	velocity = Vector2.ZERO
	disable_collision()
	animationState.travel("Death")
	
func death_animation_finish():
	weapon_spawner.spawn_weapon()

func finish_weapon_spawning():
	score_hud.increase_score()
	self.queue_free()

# in case mob didn't die properly
func _on_Despawn_timer_timeout():
	velocity = Vector2.ZERO
	hitSound.stop()
	disable_collision()
	score_hud.increase_score()
	queue_free()


func disable_collision():
	$Hitbox.set_deferred("monitorable", false)
	$Hurtbox.set_deferred("monitoring", false)
	$Hitbox/HitboxCollision.set_deferred("disabled", true)
	$Hurtbox/HurtboxCollision.set_deferred("disabled", true)
	$Detection/Detect_Area.set_deferred("monitoring", false)
	$Detection/Attack_Area.set_deferred("monitoring", false)
	$Detection/Detect_Area/Shape.set_deferred("disabled", true)
	$Detection/Attack_Area/Shape.set_deferred("disabled", true)

func enable_collision():
	$Hitbox.monitorable = true
	$Hurtbox.monitoring = true
	$Hurtbox/HurtboxCollision.disabled = false
	$Detection/Detect_Area.monitoring = true
	$Detection/Attack_Area.monitoring = true
	$Detection/Detect_Area/Shape.disabled = false
	$Detection/Attack_Area/Shape.disabled = false


