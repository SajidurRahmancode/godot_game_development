extends Node2D

var base_speed = 10
var speed = base_speed
var direction = 1
var is_dead = false

@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var ray_cast_left: RayCast2D = $RayCastLeft
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var manager: Node = %Manager

var health = 1

func _ready():
	if manager:
		print("Manager is properly referenced!")
	else:
		print("Manager is NOT referenced!")

func _process(delta: float) -> void:
	if health <= 0:
		queue_free()
		return

	speed = base_speed  # Reset speed to base speed each frame

	if ray_cast_right.is_colliding():
		var collider = ray_cast_right.get_collider()
		if collider:
			if collider.name == "PLAYER":  # Detect player on the right
				speed = base_speed * 2  # Increase speed
			else:  # Ignore the player for direction change
				direction = -1
				animated_sprite_2d.flip_h = true
		
	if ray_cast_left.is_colliding():
		var collider = ray_cast_left.get_collider()
		if collider:
			if collider.name == "PLAYER":  # Detect player on the left
				speed = base_speed * 2  # Increase speed
			else:  # Ignore the player for direction change
				direction = 1
				animated_sprite_2d.flip_h = false
		
	position.x += direction * speed * delta

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
			manager.add_point(100)

func _on_animation_finished():
	print("Animation finished. Current animation:", animated_sprite_2d.animation)
	if animated_sprite_2d.animation == "death":
		print("Death animation finished. Queueing free.")
		queue_free()		


	
