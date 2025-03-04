extends Area2D



@onready var manager: Node = %Manager



func _on_body_entered(body: Node2D) -> void:
	manager.add_point(1)
	queue_free()
