# manager.gd
extends Node

@onready var scorelabel: Label = $scorelabel
@onready var scorelabel2: Label = $scorelabel2
@onready var scorelabel3: Label = $scorelabel3
@onready var playerscore: Label = $playerscore
@onready var score_display: CanvasLayer = $"../CanvasLayer"
@onready var death_screen: Control = $"root/Game/Deathscrenetry"

var score = 0
var elapsed_time = 0.0

func _ready():
	add_to_group("manager")
	if score_display == null:
		print("Error: ScoreDisplay CanvasLayer not found in scene tree.")
	if death_screen == null:
		print("Error: DeathScreen not found in scene tree.")

func _process(delta):
	elapsed_time += delta

func add_point(points: int):
	score += points
	scorelabel.text = "Your score is: " + str(score) + "!"
	scorelabel2.text = "Your score is: " + str(score) + "!"
	scorelabel3.text = "Your score is: " + str(score) + "!"

	if score_display:
		score_display.update_score(score)

func show_death_screen():
	print("Current score: ", score, " | Time: ", elapsed_time)  # Debug
	if death_screen:
		death_screen.update_stats()
