extends Node2D

var health = 1
var cannonball_scene = preload("res://scenes/canon_ball.tscn")  # Ensure correct path

@onready var marker_2d: Marker2D = $Marker2D
@onready var shoot_timer: Timer = $ShootTimer  # Ensure Timer exists in the scene

@export var shooting: bool = true
@export var fire_rate: float = 2.0  # Fire rate in seconds

func _ready():
	if not shoot_timer:  # Ensure Timer exists in the scene
		shoot_timer = Timer.new()
		shoot_timer.wait_time = fire_rate
		shoot_timer.timeout.connect(_on_shoot_timer_timeout)
		add_child(shoot_timer)

	if shooting:
		shoot_timer.wait_time = fire_rate
		shoot_timer.start()

func _on_shoot_timer_timeout():
	fire()

func fire():
	if cannonball_scene:  # Ensure the scene is valid
		var spawn = cannonball_scene.instantiate()
		spawn.direction = marker_2d.scale.x  # Correctly assign direction
		spawn.global_position = marker_2d.global_transform.origin  # Use transform.origin instead of position

		# Ensure it's added to the correct parent
		get_parent().add_child(spawn)
	else:
		print("Cannonball scene failed to load!")
