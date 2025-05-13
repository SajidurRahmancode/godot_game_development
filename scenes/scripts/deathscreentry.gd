# deathscreen.gd
extends Control

@onready var color_rect: ColorRect = $ColorRect
@onready var score_label: Label = $ScoreLabel
@onready var time_label: Label = $TimeLabel
@onready var restart_button: Button = $RestartButton
@onready var continue_button: Button = $ContinueButton

func _ready():
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	if color_rect:
		color_rect.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	
	_center_elements()

	_update_labels()

	_update_scaling()

func _center_elements():
	# Center labels horizontally
	for label in [score_label, time_label]:
		if label:
			label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			label.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	
	# Center buttons properly
	for button in [restart_button, continue_button]:
		if button:
			button.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
			# Proper way to center button text in Godot 4
			button.alignment = HORIZONTAL_ALIGNMENT_CENTER

func _update_labels():
	if score_label:
		score_label.text = "Score: " + str(GameData.get_score())
	
	if time_label:
		var time = GameData.get_time()
		var minutes: int = int(time) / 60
		var seconds: int = int(time) % 60
		time_label.text = "Time: %02d:%02d" % [minutes, seconds]

func _update_scaling():
	var viewport_size = get_viewport_rect().size
	var base_size = Vector2(1280, 720)  # Reference size
	
	# Calculate scale factor with reasonable limits
	var scale_factor = clamp(min(
		viewport_size.x / base_size.x,
		viewport_size.y / base_size.y
	), 0.7, 1.5)
	
	# Apply scaling to fonts
	var font_size = int(32 * scale_factor)
	var button_font_size = int(28 * scale_factor)
	
	if score_label:
		score_label.add_theme_font_size_override("font_size", font_size)
	if time_label:
		time_label.add_theme_font_size_override("font_size", font_size)
	if restart_button:
		restart_button.add_theme_font_size_override("font_size", button_font_size)
	if continue_button:
		continue_button.add_theme_font_size_override("font_size", button_font_size)
	
	# Adjust margins based on screen size
	var vertical_spacing = int(50 * scale_factor)
	if score_label:
		score_label.add_theme_constant_override("margin_bottom", vertical_spacing)
	if time_label:
		time_label.add_theme_constant_override("margin_bottom", vertical_spacing * 2)
	
	# Set button minimum sizes
	var button_min_size = Vector2(200 * scale_factor, 60 * scale_factor)
	if restart_button:
		restart_button.custom_minimum_size = button_min_size
	if continue_button:
		continue_button.custom_minimum_size = button_min_size




func _notification(what):
	if what == NOTIFICATION_RESIZED:
		_update_scaling()

"""
func _on_continue_button_pressed() -> void:
	var player = get_tree().get_first_node_in_group("player") # Make sure to add player to "Player" group!
	if player:
		player.respawn()
	queue_free()"""
