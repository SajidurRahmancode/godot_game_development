extends CharacterBody2D

@export var dialogue_resource: DialogueResource  # Assign in Inspector
@export var quest_id: String = "find_sword"

@onready var dialogue_manager: Node = get_node("/root/DialogueManager")

const speed = 30
enum { IDLE, NEW_DIR, MOVE }
var current_state = IDLE
var dir = Vector2.RIGHT
var start_pos
var is_roaming = true
var is_chatting = false

var player
var player_inchatzone = false

func _ready() -> void:
	randomize()
	start_pos = position
	print_debug("[NPC] Ready at position:", start_pos)

	if dialogue_manager:
		print_debug("[NPC] DialogueManager found")
		# Try connecting to both possible signal names
		if dialogue_manager.has_signal("dialogue_ended"):
			dialogue_manager.dialogue_ended.connect(_on_dialogue_ended)
		elif dialogue_manager.has_signal("finished"):
			dialogue_manager.finished.connect(_on_dialogue_ended)
	else:
		print_debug("[NPC ERROR] DialogueManager NOT found!")

func _process(delta: float) -> void:
	if is_chatting:
		return

	if current_state == IDLE or current_state == NEW_DIR:
		$AnimatedSprite2D.play("idle")

	if player_inchatzone and Input.is_action_just_pressed("interact"):
		print_debug("[NPC] Player pressed interact!")
		start_dialogue()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player = body
		player_inchatzone = true
		print_debug("[NPC] Player entered chat zone!")

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_inchatzone = false
		print_debug("[NPC] Player exited chat zone!")

func start_dialogue() -> void:
	if dialogue_manager and dialogue_resource:
		is_chatting = true
		print_debug("[NPC] Starting dialogue...")
		var balloon = dialogue_manager.show_dialogue_balloon(dialogue_resource)
		# Alternative connection to the balloon itself
		if balloon and balloon.has_signal("finished"):
			balloon.finished.connect(_on_dialogue_ended.bind(), CONNECT_ONE_SHOT)

func _on_dialogue_ended():
	is_chatting = false
	print_debug("[NPC] Dialogue ended.")

	if quest_id != "":
		print_debug("[NPC] Attempting to activate quest:", quest_id)
		
		# Access QuestManager as singleton
		var quest_manager = get_node("/root/QuestManager")
		if quest_manager:
			if not quest_manager.is_quest_active(quest_id) and not quest_manager.is_quest_completed(quest_id):
				quest_manager.activate_quest(quest_id)
				print_debug("[NPC] Quest started:", quest_id)
			else:
				print_debug("[NPC] Quest already active or completed.")
