extends Node

@onready var scorelabel: Label = $scorelabel
# Called when the node enters the scene tree for the first time.
var score=0

func add_point():
	score+=1
	scorelabel.text="You collected "+str(score)+" coins."
