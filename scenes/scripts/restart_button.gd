extends Button

func _ready():
	pass
	
func _pressed() -> void:
	GameData.set_time(0.0)  # Also reset GameData time
	get_tree().change_scene_to_file("res://scenes/game.tscn")
	
	

	
