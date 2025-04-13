extends RigidBody3D

@export var explosion_delay: float = 3.0  # Time until grenade "explodes"
@export var kill_radius: float = 5.0      # Range for instant kill
@export var damage: int = 100            # High damage for instant kill

var timer: Timer
var has_activated: bool = false

func _ready():
	# Create and configure timer
	timer = Timer.new()
	add_child(timer)
	timer.timeout.connect(_on_timer_complete)
	timer.one_shot = true

func activate():
	if has_activated:
		return
		
	has_activated = true
	timer.start(explosion_delay)

func _on_timer_complete():
	kill_nearby_enemies()
	queue_free()  # Remove grenade after doing damage

func kill_nearby_enemies():
	# Get all bodies in kill radius
	var space_state = get_world_3d().direct_space_state
	var query = PhysicsShapeQueryParameters3D.new()
	query.shape = SphereShape3D.new()
	query.shape.radius = kill_radius
	query.transform.origin = global_transform.origin
	query.collision_mask = collision_mask  # Make sure this matches enemy layers
	
	var results = space_state.intersect_shape(query)
	
	for result in results:
		var body = result.collider
		# Check if body is an enemy and has health/die method
		if body.is_in_group("enemy"):
			if body.has_method("die"):
				body.die()
			elif body.has_method("take_damage"):
				body.take_damage(damage)
