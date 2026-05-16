extends Node

signal pauseAnxiety()
signal restartAnxiety()
signal sendAnxietyChange(anxiety: int)
signal closeBreathing()

# property
@export var minigame : int = defs.MINIGAME.BREATHING_GAME
@export var success_anxiety_change : int = -20
@export var fail_anxiety_change : int = 80

@onready var movingBox = $"breatheMover"
@onready var clickInBox = $"breatheClickIn"
@onready var lungAnimation = $"Lungs/AnimationPlayer"
var startingPos = 80
var endingPos = 1043
var curPos = 80
var dir = 1
var increment = 400	# pixel per second
var minSize = 25
var maxSize = 40
var curSize = 0
var boxCurPos = 0

func _ready() -> void:
	movingBox.position =Vector2(startingPos,326)
	curSize = 474
	boxCurPos = 549 - 430
	clickInBox.size = Vector2(curSize,58)
	clickInBox.position = Vector2(boxCurPos,317)
	lungAnimation.current_animation = "LungsBreatheIn"

func _input(event: InputEvent) -> void:
	if Input.is_action_pressed("breathing_minigame_breath"):
		if (curPos > boxCurPos and curPos< boxCurPos+curSize) or (curPos+ 14 > boxCurPos and curPos+14 <boxCurPos+curSize):
			emit_signal("sendAnxietyChange",success_anxiety_change)
		else:
			emit_signal("sendAnxietyChange",fail_anxiety_change)
	
func newRandPositionBox():
	curSize = randi_range(minSize,maxSize)
	
	clickInBox.size = Vector2(curSize,58)
	#clickInBox.position = Vector2(boxCurPos,317)


func _process(delta: float) -> void:
	if curPos + increment * delta < endingPos and dir == 1:
		curPos += increment * delta
		movingBox.position = Vector2(curPos,326)
	elif curPos -increment * delta > startingPos and dir == -1:
		curPos -= increment * delta
		movingBox.position = Vector2 (curPos,326)
	elif dir == 1:
		dir = -1
		boxCurPos = 549
		clickInBox.position = Vector2(boxCurPos,317)
		lungAnimation.current_animation = "LungsBreatheOut"
	elif dir == -1:
		dir = 1
		boxCurPos = 549 - 430
		clickInBox.position = Vector2(boxCurPos,317)
		lungAnimation.current_animation = "LungsBreatheIn"
