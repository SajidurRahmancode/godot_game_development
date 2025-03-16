extends Node

@onready var scorelabel: Label = $scorelabel
@onready var scorelabel2: Label = $scorelabel2
@onready var scorelabel3: Label = $scorelabel3

@onready var playerscore: Label = $playerscore



var score = 0

func add_point(points): # Corrected: Added 'points' parameter
	score += points # Corrected: Added score by the points parameter
	scorelabel.text = "Your score is: " + str(score) + "!"
	scorelabel2.text = "Your score is: " + str(score) + "!"
	scorelabel3.text = "Your score is: " + str(score) + "!"
