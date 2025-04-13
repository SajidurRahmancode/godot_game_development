extends Area2D


@onready var timer: Timer = $Timer



func _on_body_entered(body: Node2D) -> void:
	print("Killzone triggered by:", body.name)
	if "PLAYER" in body.name:
		print("Player died")
		var hud = get_tree().current_scene.get_node("CanvasLayer")  # adjust path if needed
		hud.save_time()  # Store time before leaving
		
		timer.start()
		get_tree().change_scene_to_file("res://scenes/deathscreentry.tscn")


func _on_timer_timeout() -> void:
	Engine.time_scale = 1.0
	get_tree().reload_current_scene()
