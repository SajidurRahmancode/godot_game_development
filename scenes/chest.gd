extends Area2D

@onready var manager: Node = %Manager
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var is_opened: bool = false  # Track if the chest is already opened
var player_in_area: bool = false  # Track if the player is near the chest

func _ready():
	set_process_input(true)  # Enable input processing

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_area = true  # Player is near the chest

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_area = false  # Player left the chest's area

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and player_in_area and not is_opened:
		open_chest()

func open_chest() -> void:
	is_opened = true  # Mark chest as opened
	manager.add_point(50)
	animated_sprite.play("open")  # Play the chest opening animation
