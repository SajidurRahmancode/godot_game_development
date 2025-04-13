extends Node2D
var is_paused = false
var pause_menu_instance = null

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		if not is_paused:  # Only allow pausing from game
			toggle_pause()

func toggle_pause():
	is_paused = !is_paused
	get_tree().paused = is_paused
	
	if is_paused:
		# Show pause menu
		pause_menu_instance = preload("res://scenes/pause_menu.tscn").instantiate()
		pause_menu_instance.process_mode = PROCESS_MODE_ALWAYS
		pause_menu_instance.connect("resume_requested", _on_resume_requested)
		add_child(pause_menu_instance)
	else:
		# Remove pause menu if it exists
		if pause_menu_instance:
			pause_menu_instance.queue_free()
			pause_menu_instance = null

func _on_resume_requested():
	toggle_pause()

func _on_quit_to_menu_requested():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
