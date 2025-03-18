# manager.gd
extends Node

@onready var scorelabel: Label = $scorelabel
@onready var scorelabel2: Label = $scorelabel2
@onready var scorelabel3: Label = $scorelabel3

@onready var playerscore: Label = $playerscore

@onready var score_display: CanvasLayer = $"../CanvasLayer"  # Ensure this path is correct

var score = 0

func _ready():
	if score_display == null:
		print("Error: ScoreDisplay CanvasLayer not found in scene tree.")

func add_point(points: int):
	score += points
	scorelabel.text = "Your score is: " + str(score) + "!"
	scorelabel2.text = "Your score is: " + str(score) + "!"
	scorelabel3.text = "Your score is: " + str(score) + "!"

	if score_display:
		score_display.update_score(score)  # Calls the function in the canvas layer to update the score
