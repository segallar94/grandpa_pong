extends CanvasLayer

onready var p1Score = get_parent().get_node("Ball").p1Score
onready var p2Score = get_parent().get_node("Ball").p2Score

# Called when the node enters the scene tree for the first time.
func _ready():
	$ScoreLeft.text = str(p1Score)
	$ScoreRight.text = str(p2Score)


func _on_Ball_updateScore(player, score):
	if (player == "Player1"):
		$ScoreLeft.text = str(score)
	else:
		$ScoreRight.text = str(score)
