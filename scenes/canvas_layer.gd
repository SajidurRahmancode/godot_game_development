extends CanvasLayer

@onready var score_label: Label = $Label
@onready var camera: Camera2D = null  # Reference to the Camera2D
@onready var time_label: Label = $Time
var elapsed_time: float = 0.0

func _ready():
	add_to_group("HUD")  # Add this line

	await get_tree().process_frame  # Ensure the scene is fully loaded
	camera = get_viewport().get_camera_2d()  # Get the active Camera2D

func _process(delta):
	if camera:
		offset = camera.global_position  # Use offset instead of global_position
	elapsed_time += delta
	time_label.text = "Time: " + str(elapsed_time as int) + "s"  # Display as whole seconds

func update_score(new_score: int):
	GameData.update_score(new_score)
	score_label.text = "Score: " + str(new_score)

func update_time_display():
	var minutes: int = int(elapsed_time) / 60
	var seconds: int = int(elapsed_time) % 60
	time_label.text = "Time: %02d:%02d" % [minutes, seconds]
	
func save_time():
	GameData.set_time(elapsed_time)

func reset_time():
	elapsed_time = 0.0

	
