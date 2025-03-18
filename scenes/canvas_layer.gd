extends CanvasLayer

@onready var score_label: Label = $Label
@onready var camera: Camera2D = null  # Reference to the Camera2D

func _ready():
	await get_tree().process_frame  # Ensure the scene is fully loaded
	camera = get_viewport().get_camera_2d()  # Get the active Camera2D

func _process(delta):
	if camera:
		offset = camera.global_position  # Use offset instead of global_position

func update_score(score: int):
	score_label.text = "Score: " + str(score)
