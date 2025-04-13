# deathscreen.gd
extends Control


@onready var score_label: Label = $ScoreLabel
@onready var time_label: Label = $TimeLabel
@onready var restart_button: Button = $RestartButton

func _ready():
	score_label.text = "Score:" + str(GameData.get_score())
	
	var time = GameData.get_time()
	var minutes: int = int(time) / 60
	var seconds: int = int(time) % 60
	time_label.text = "Time: %02d:%02d" % [minutes, seconds]
