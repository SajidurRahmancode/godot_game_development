extends Area2D

@export var respawn_point: Node2D  # Assign in editor
var checkpoint_manager: Node = null

func _ready() -> void:
	# More reliable way to find checkpoint manager
	checkpoint_manager = get_node("/root/Scene/CheckpointManager")  # Adjust path to your scene structure
	if not checkpoint_manager:
		checkpoint_manager = get_tree().get_first_node_in_group("CheckpointManager")
	
	if not checkpoint_manager:
		printerr("Checkpoint: Could not find CheckpointManager!")
		queue_free()
	
	if not respawn_point:
		printerr("Checkpoint: No respawn point assigned!")
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") and checkpoint_manager and respawn_point:
		checkpoint_manager.last_location = respawn_point.global_position
		print("Checkpoint activated at position: ", respawn_point.global_position)
