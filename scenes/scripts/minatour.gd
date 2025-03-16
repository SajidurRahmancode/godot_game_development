extends CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var facing_left = true
var speed = 60.0  # Start moving left
var health = 1
var is_dead = false

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var manager: Node = %Manager

func _ready():
	update_ray_direction()  # Ensure the RayCast2D points correctly on start
	if manager:
		print("Manager is properly referenced!")
	else:
		print("Manager is NOT referenced!")

func _physics_process(delta: float) -> void:
	if is_dead:
		return

	if not is_on_floor():
		velocity.y += gravity * delta

	# Check if the RayCast2D is colliding, flip if it reaches an edge
	if (!$RayCast2D.is_colliding() or !$RayCast2D2) and is_on_floor():
		flip()

	velocity.x = speed
	move_and_slide()

func flip():
	facing_left = !facing_left
	scale.x *= -1  # Flip the character sprite
	speed *= -1  # Reverse the movement direction
	update_ray_direction()  # Adjust RayCast2D

func update_ray_direction():
	# Move RayCast2D to always point forward
	$RayCast2D.position.x  = abs($RayCast2D.position.x) * (-1 if facing_left else 1)




func _on_killzone_body_entered(body: Node2D) -> void:
	if "player" in body.name:
		body.queue_free()
	print("Something entered killzone!")

func _on_getdamagebox_body_entered(body: Node2D) -> void:
	if "PLAYER" in body.name:
		health -= 1
		if health <= 0:
			print("Enemy health is zero. Playing death animation.")
			animated_sprite_2d.play("death")
			print("Death animation played.")
			manager.add_point(150)
		
			queue_free()	
