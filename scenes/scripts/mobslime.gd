extends CharacterBody2D

@onready var player: CharacterBody2D = get_node("/root/Game/PLAYER")  # Directly get the player node
@onready var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

var is_following: bool = false
var follow_timer: float = 0.0
var jump_cooldown: float = 0.0
var is_jumping: bool = false

const FOLLOW_RANGE: float = 300.0
const FOLLOW_DURATION: float = 5.0
const JUMP_VELOCITY: float = -300.0
const JUMP_COOLDOWN: float = 1.0
const MOVE_SPEED: float = 100.0
const DEFAULT_MOVE_SPEED: float = 50.0  # Speed for default movement

var default_direction: Vector2 = Vector2.RIGHT  # Default movement direction

func _physics_process(delta: float) -> void:
	queue_redraw()  # Update debug line
	print("Physics process running")

	if player == null:
		print("Player node not found!")
		return

	# Apply gravity
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		is_jumping = false

	# Check if player is in range and in line of sight
	var player_distance = global_position.distance_to(player.global_position)
	var can_see_player = player_distance <= FOLLOW_RANGE and _is_player_in_sight()

	# Follow player if in range and in sight
	if can_see_player:
		if not is_following:
			is_following = true
			follow_timer = 0.0

		follow_timer += delta
		if follow_timer <= FOLLOW_DURATION:
			var direction = (player.global_position - global_position).normalized()
			velocity.x = direction.x * MOVE_SPEED

			# Jump if there's an obstacle or gap in front of the slime
			if is_on_floor() and jump_cooldown <= 0.0 and _is_obstacle_ahead():
				velocity.y = JUMP_VELOCITY
				is_jumping = true
				jump_cooldown = JUMP_COOLDOWN
		else:
			is_following = false
	else:
		is_following = false

	# Default behavior when not following
	if not is_following:
		print("Default movement active")
		velocity.x = default_direction.x * DEFAULT_MOVE_SPEED

		# Reverse direction if hitting a wall or reaching the edge of a platform
		if is_on_wall() or not _is_ground_ahead():
			print("Reversing direction")
			default_direction *= -1

	# Cooldown for jumping
	if jump_cooldown > 0.0:
		jump_cooldown -= delta

	move_and_slide()

	print("Velocity: ", velocity)
	print("Is on floor: ", is_on_floor())
	print("Is on wall: ", is_on_wall())
	print("Ground ahead: ", _is_ground_ahead())

func _is_player_in_sight() -> bool:
	var space_state = get_world_2d().direct_space_state
	var ray_query = PhysicsRayQueryParameters2D.create(global_position, player.global_position)
	ray_query.exclude = [self]  # Exclude the slime itself from the raycast
	var result = space_state.intersect_ray(ray_query)
	
	# Check if the ray hit something and if the collider is the player
	if result and result.has("collider"):
		print("Player in sight")
		return result["collider"] == player
	print("Player not in sight")
	return false

func _is_obstacle_ahead() -> bool:
	# Check for obstacles or gaps in front of the slime
	var ray_length = 100.0  # Adjust based on the slime's size
	var ray_direction = Vector2.RIGHT if velocity.x > 0 else Vector2.LEFT
	var ray_start = global_position + Vector2(0, -10)  # Adjust based on the slime's collision shape
	var ray_end = ray_start + ray_direction * ray_length

	var space_state = get_world_2d().direct_space_state
	var ray_query = PhysicsRayQueryParameters2D.create(ray_start, ray_end)
	ray_query.exclude = [self]  # Exclude the slime itself from the raycast
	var result = space_state.intersect_ray(ray_query)

	# If there's no result (no collision), there's a gap
	if not result:
		print("No obstacle ahead (gap detected)")
		return true

	# If the collider is not in the "ground" group, it's an obstacle
	if result.has("collider") and not result["collider"].is_in_group("ground"):
		print("Obstacle ahead: ", result["collider"])
		return true

	print("No obstacle ahead")
	return false

func _is_ground_ahead() -> bool:
	# Check if there's ground ahead for default movement
	var ray_length = 100.0  # Adjust based on the slime's size
	var ray_direction = default_direction
	var ray_start = global_position + Vector2(0, -10)  # Adjust based on the slime's collision shape
	var ray_end = ray_start + ray_direction * ray_length

	var space_state = get_world_2d().direct_space_state
	var ray_query = PhysicsRayQueryParameters2D.create(ray_start, ray_end)
	ray_query.exclude = [self]  # Exclude the slime itself from the raycast
	var result = space_state.intersect_ray(ray_query)

	# If there's no result (no collision), there's no ground ahead
	if not result:
		print("No ground ahead")
		return false

	# If the collider is in the "ground" group, there's ground ahead
	if result.has("collider") and result["collider"].is_in_group("ground"):
		print("Ground ahead: ", result["collider"])
		return true

	print("No ground ahead")
	return false

func _draw():
	if Engine.is_editor_hint():
		return
	var ray_length = 100.0
	var ray_direction = default_direction
	var ray_start = global_position + Vector2(0, -10)
	var ray_end = ray_start + ray_direction * ray_length
	draw_line(ray_start - global_position, ray_end - global_position, Color(1, 0, 0), 2)
