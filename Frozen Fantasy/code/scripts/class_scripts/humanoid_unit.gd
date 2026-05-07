extends Node3D #highly likely that this will actually inherit the animation model
class_name Humanoid

@onready var animation: AnimationPlayer = $Animation

"""
Functionality:
	This is primarily here for animations, general movement, etc. 

"""

var animation_pools = {
	"idle": ["idle", "idle1", "idle2", "idle3"],
	"attack": ["attack", "attack1", "attack2", "attack3", "attack4"],
	"walk": ["walk", "walk1", "walk2", "walk3", "walk_end"],
	"gather": ["gather"],
	"die": ["die", "die1", "die2", "die3", "die4"]
}

var unit = null
var last_state: int = -1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	unit = get_parent()
	animation.animation_finished.connect(_on_animation_finished)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var state = unit.get_curState()
	
	if state != last_state:
		last_state = state

		match state:
			unit.State.IDLE:
				_play_random_from_pool("idle")
			unit.State.ATTACK:
				_play_random_from_pool("attack")
			unit.State.MOVE_PATH, unit.State.MOVE_DIRECTION, unit.State.FOLLOW, unit.State.PATROL, unit.State.ROAM:
				_play_random_from_pool("walk")
			unit.State.GATHER:
				animation.play("gather")
			unit.State.DEAD:
				_play_random_from_pool("die")
			_:
				pass

func _on_animation_finished(anim_name: String) -> void:
	match last_state:
		unit.State.ATTACK:
			_play_random_from_pool("attack")
		unit.State.IDLE:
			if animation_pools["walk"].filter(func(anim): return animation.has_animation(anim)).has("walk_end"):
				animation.play("walk_end")
			_play_random_from_pool("idle")
		unit.State.MOVE_PATH, unit.State.MOVE_DIRECTION, unit.State.FOLLOW, unit.State.PATROL, unit.State.ROAM:
			_play_random_from_pool("walk")

func _play_random_from_pool(state_name: String):
	if not animation_pools.has(state_name):
		return
	var pool = animation_pools[state_name].filter(func(anim): return animation.has_animation(anim))
	var anim = pool.pick_random()
	if animation.current_animation != anim:
		animation.play(anim)
