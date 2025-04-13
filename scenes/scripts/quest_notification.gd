extends Control

@onready var panel: Panel = $Panel
@onready var label: Label = $Panel/Label

@export var display_time: float = 3.0
@export var fade_time: float = 0.3
var current_tween: Tween = null

func _ready():
	print("[DEBUG_NOTIFICATION] Notification control ready")
	print("[DEBUG_NOTIFICATION] Panel path valid: ", panel != null)
	print("[DEBUG_NOTIFICATION] Label path valid: ", label != null)
	hide()

func show_quest_notification(quest_text: String):
	print("[DEBUG_NOTIFICATION] Showing notification: ", quest_text)
	
	if not panel or not label:
		printerr("[ERROR_NOTIFICATION] Missing panel or label reference!")
		return
	
	# Cancel any existing animation
	if current_tween and current_tween.is_running():
		current_tween.kill()
	
	label.text = quest_text
	panel.modulate.a = 0
	show()
	print("[DEBUG_NOTIFICATION] Notification made visible")
	
	# Fade in
	print("[DEBUG_NOTIFICATION] Starting fade in")
	current_tween = create_tween()
	current_tween.tween_property(panel, "modulate:a", 1.0, fade_time)
	await current_tween.finished
	print("[DEBUG_NOTIFICATION] Fade in complete")
	
	# Wait
	print("[DEBUG_NOTIFICATION] Waiting display time")
	await get_tree().create_timer(display_time).timeout
	
	# Fade out
	print("[DEBUG_NOTIFICATION] Starting fade out")
	current_tween = create_tween()
	current_tween.tween_property(panel, "modulate:a", 0.0, fade_time)
	await current_tween.finished
	print("[DEBUG_NOTIFICATION] Fade out complete")
	
	hide()
	print("[DEBUG_NOTIFICATION] Notification hidden")
