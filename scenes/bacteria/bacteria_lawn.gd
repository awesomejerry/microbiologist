extends Node2D

@export var bacteria_scene: PackedScene

var center: Vector2
var radius: float
var initial_radius: float
var final_radius: float

var elapsed_time: float
var growth_phase: int

func _ready() -> void:
	center = global_position

	var screen_size = get_viewport_rect().size
	var collision_shape = $Area2D/CollisionShape2D
	var circle_shape = collision_shape.shape as CircleShape2D
	radius = circle_shape.radius if circle_shape else screen_size.x / 2
	initial_radius = radius
	final_radius = radius * 4

	$Timer.connect('timeout', spawn_bacteria)
	spawn_bacteria()

func _process(delta: float) -> void:
	elapsed_time += delta
	if (elapsed_time < 10):
		growth_phase = 0
	elif (elapsed_time < 30):
		growth_phase = 1
	elif (elapsed_time < 60):
		growth_phase = 2
	else:
		growth_phase = 3
	radius = lerp(initial_radius, final_radius, elapsed_time / 60)

func spawn_bacteria() -> void:
	var bacteria_count = 0
	match growth_phase:
		0: bacteria_count = 1 # Lag phase
		1: bacteria_count = int(2 * elapsed_time / 20) # Logarithmic phase
		2: bacteria_count = max(0, 4 - int((elapsed_time - 30) / 5)) # Stationary phase
		3: bacteria_count = 0 # Decline phase

	for i in range(bacteria_count):
		var bacteria = bacteria_scene.instantiate()
		bacteria.add_to_group("Bacteria")

		var random_angle = randf() * 2 * PI
		var random_radius = sqrt(randf()) * radius
		
		var random_position = center + Vector2(
			cos(random_angle) * random_radius,
			sin(random_angle) * random_radius
		)
		
		bacteria.global_position = random_position
		get_parent().add_child(bacteria)
