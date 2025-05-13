extends Area2D

@onready var dialogue_manager = get_node("/root/DialogueManager")
@onready var quest_system = get_node("/root/QuestSystem")
@export var dialogue_resource: DialogueResource

# Notification system
@export var quest_notification_scene: PackedScene
var quest_notification: Control = null
var dialogue_active: bool = false
var current_balloon: CanvasLayer = null  # Add this to track the current balloon

func _ready() -> void:
	print("[DEBUG] Area2D ready - initializing...")
	body_entered.connect(_on_body_entered)
	print("[DEBUG] Connected body_entered signal")

	# Instantiate notification
	if quest_notification_scene:
		print("[DEBUG] Instantiating notification scene")
		quest_notification = quest_notification_scene.instantiate()
		get_tree().root.add_child(quest_notification)
		quest_notification.hide()
		print("[DEBUG] Notification scene added to tree")
	else:
		printerr("[ERROR] No quest_notification_scene assigned!")

func _input(event: InputEvent) -> void:
	# Add this new function to handle ESC key press
	if event.is_action_pressed("ui_cancel") and dialogue_active and current_balloon:
		print("[DEBUG] ESC pressed - closing dialogue")
		close_dialogue()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and not dialogue_active:
		print("[DEBUG] Player entered area - starting dialogue")
		dialogue_active = true
		start_dialogue()

func start_dialogue() -> void:
	if not dialogue_manager:
		printerr("[ERROR] No dialogue_manager found!")
		dialogue_active = false
		return

	if not dialogue_resource:
		printerr("[ERROR] No dialogue_resource assigned!")
		dialogue_active = false
		return

	print("[DEBUG] Attempting to show dialogue balloon")
	current_balloon = dialogue_manager.show_dialogue_balloon(dialogue_resource)

	if current_balloon:
		print("[DEBUG] Dialogue balloon created successfully")

		# Connect to available signals instead
		if dialogue_manager.has_signal("got_dialogue"):
			dialogue_manager.got_dialogue.connect(_on_dialogue_line)
		else:
			printerr("[ERROR] DialogueManager missing got_dialogue signal!")

		if dialogue_manager.has_signal("dialogue_ended"):
			dialogue_manager.dialogue_ended.connect(_on_dialogue_ended)
	else:
		printerr("[ERROR] Failed to create dialogue balloon!")
		dialogue_active = false

func close_dialogue() -> void:
	# New function to cleanly close the dialogue
	if current_balloon:
		current_balloon.queue_free()
		current_balloon = null
	
	dialogue_active = false
	# Emit the ended signal manually since we're skipping
	dialogue_manager.dialogue_ended.emit(dialogue_resource)
	print("[DEBUG] Dialogue closed via ESC")

func _on_dialogue_line(line: DialogueLine):
	print("[DEBUG] Received dialogue line: ", line)

	# Check for quest triggers in the line's text or metadata
	if "[quest_start" in line.text:
		var quest_id = line.text.split("[quest_start ")[1].split("]")[0].strip_edges()
		handle_quest_start(quest_id)
	elif "[quest_complete" in line.text:
		var quest_id = line.text.split("[quest_complete ")[1].split("]")[0].strip_edges()
		handle_quest_complete(quest_id)

func handle_quest_start(quest_id: String) -> void:
	print("[DEBUG] Handling quest start for: ", quest_id)

	if quest_system:
		if quest_system.has_method("start_quest"):
			print("[DEBUG] Calling start_quest on quest system")
			var result = quest_system.start_quest(quest_id)
			print("[DEBUG] Quest start result: ", result)

			if quest_notification:
				var quest_name = quest_id
				if quest_system.has_method("get_quest_name"):
					quest_name = quest_system.get_quest_name(quest_id)
					print("[DEBUG] Retrieved quest name: ", quest_name)

				print("[DEBUG] Attempting to show notification")
				if quest_notification.has_method("show_quest_notification"):
					quest_notification.show_quest_notification("Quest Started: " + quest_name)
				else:
					printerr("[ERROR] Notification missing show_quest_notification method!")
			else:
				printerr("[ERROR] No quest_notification available!")
		else:
			printerr("[ERROR] QuestSystem missing start_quest method!")
	else:
		printerr("[ERROR] No quest_system found!")

func handle_quest_complete(quest_id: String) -> void:
	print("[DEBUG] Handling quest complete for: ", quest_id)
	if quest_system and quest_system.has_method("complete_quest"):
		var result = quest_system.complete_quest(quest_id)
		print("[DEBUG] Quest complete result: ", result)

		if quest_notification and quest_notification.has_method("show_quest_notification"):
			var quest_name = quest_id
			if quest_system.has_method("get_quest_name"):
				quest_name = quest_system.get_quest_name(quest_id)
			quest_notification.show_quest_notification("Quest Completed: " + quest_name)

func _on_dialogue_ended():
	print("[DEBUG] Dialogue ended")
	dialogue_active = false
	current_balloon = null  # Clear reference when dialogue ends normally
