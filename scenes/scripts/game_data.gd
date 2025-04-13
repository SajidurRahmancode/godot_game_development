# game_data.gd
extends Node

var score: int = 0
var time: float = 0.0

func update_score(new_score: int) -> void:
	score = new_score

func get_score() -> int:
	return score

func set_time(new_time: float) -> void:
	time = new_time

func get_time() -> float:
	return time

func reset():
	score = 0
	time = 0.0
