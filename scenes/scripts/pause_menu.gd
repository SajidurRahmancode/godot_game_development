extends Control

signal resume_requested
signal quit_to_menu_requested


func _ready():
	# Make sure buttons work while paused
	process_mode = PROCESS_MODE_ALWAYS



func _on_resume_button_pressed():
		emit_signal("resume_requested")




func _on__on_quit_to_menu_pressed() -> void:
	emit_signal("quit_to_menu_requested")
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
