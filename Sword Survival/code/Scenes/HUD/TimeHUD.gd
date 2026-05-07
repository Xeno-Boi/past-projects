extends CanvasLayer

# scene
#onready var score_sheet = get_node("/root/score_sheet.gd")

# child
onready var time = $Time
onready var timer = $Timer

# trackers
var minute: int
var second: int


# displays stuff
func _ready():
	var minute: int = 0
	var second: int = 0
	update_time(minute, second)
	timer.start()
	

func update_time(minutes, seconds):
	time.text = String(minutes).pad_zeros(2) + ":" + String(seconds).pad_zeros(2)
	ScoreSheet.time_survived = time.text


func _on_Timer_timeout():
	second += 1
	if second == 60:
		minute += 1
		second = 0
	update_time(minute, second)
