extends Node

var last_location: Vector2 = Vector2.ZERO
var player: CharacterBody2D = null

func _ready():
	# Find player more reliably
	player = get_tree().get_first_node_in_group("Player")
	if player:
		last_location = player.global_position
	else:
		printerr("CheckpointManager: Could not find Player node!")
		# Set a default position if needed
		last_location = Vector2(100, 100)  # Adjust to your level's start position

func respawn_player():
	if player and is_instance_valid(player):
		player.global_position = last_location
		player.velocity = Vector2.ZERO
	else:
		# Try to find player again if reference was lost
		player = get_tree().get_first_node_in_group("Player")
		if player:
			player.global_position = last_location
			player.velocity = Vector2.ZERO
		else:
			printerr("CheckpointManager: Player node missing during respawn!")
			get_tree().reload_current_scene()
