extends CanvasLayer

# child
onready var score_text = $Score

# trackers
var score: int

func _ready():
	score = 0
	update_score_text()

func update_score_text():
	score_text.text = String(score)
	ScoreSheet.score = score_text.text
	
func increase_score():
	score += 1
	update_score_text()


