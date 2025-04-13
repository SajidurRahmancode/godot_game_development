extends Node2D

var direction = 1
var speed = 200.0
var lifetime = 1.0
var hit = false

@onready var timer: Timer = $ShootTimer
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	if timer:
		timer.start(lifetime)  # Ensure timer starts
	else:
		print("Error: Timer node missing in cannonball scene!")

func _physics_process(delta: float) -> void:
	if not hit:
		position.x += speed * delta * direction  # Correct movement logic

func die():
	hit = true
	speed = 0
	animation_player.play("hit")

func _on_killzone_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):  # Check if player is in the correct group
		body.queue_free()
		print("Player hit!")

func _on_timer_timeout():
	die()
