extends Node

@onready var scorelabel: Label = $scorelabel
@onready var scorelabel2: Label = $scorelabel2
@onready var playerscore: Label = $playerscore



var score = 0

func add_point(points): # Corrected: Added 'points' parameter
	score += points # Corrected: Added score by the points parameter
	scorelabel.text = "Your score: " + str(score) + "!"
	scorelabel2.text = "Your score: " + str(score) + "!"
