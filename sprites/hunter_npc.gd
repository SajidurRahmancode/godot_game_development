extends CharacterBody2D

@export var dialogue_resource: DialogueResource  # Assign in Inspector

@onready var dialogue_manager: Node = get_node("/root/DialogueManager")
@onready var dialogue_label = $DialogueLabel  # Get DialogueLabel node

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
	print_debug("[NPC] Ready! Position:", start_pos)

	# Debug: Check if dialogue manager is found
	if dialogue_manager:
		print_debug("[NPC] DialogueManager found:", dialogue_manager)
		# Connect to DialogueManager signals
		dialogue_manager.dialogue_ended.connect(_on_dialogue_ended)
		dialogue_manager.got_dialogue.connect(_on_dialogue_updated)
	else:
		print_debug("[NPC ERROR] DialogueManager NOT found!")

func _process(delta: float) -> void:
	if is_chatting:
		return  # Stop movement while chatting

	if current_state == IDLE or current_state == NEW_DIR:
		$AnimatedSprite2D.play("idle")

	# Check if player presses interact key and is in range
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
		dialogue_manager.show_dialogue_balloon(dialogue_resource)
	else:
		print_debug("[NPC ERROR] Cannot start dialogue. Missing manager or resource!")
		
func _on_dialogue_updated(line: DialogueLine) -> void:
	if dialogue_label:
		print_debug("[NPC] Dialogue updated:", line.text)
		dialogue_label.dialogue_line = line
		dialogue_label.type_out()  # Start typing out the dialogue

func _on_dialogue_ended(_resource: DialogueResource):
	is_chatting = false
	dialogue_label.text = ""  # Clear dialogue when done
	print_debug("[NPC] Dialogue ended.")
