extends Node2D

@export var bacteria_scene: PackedScene

var center: Vector2
var radius: float

func _ready() -> void:
	center = global_position

	var screen_size = get_viewport_rect().size
	var collision_shape = $Area2D/CollisionShape2D
	var circle_shape = collision_shape.shape as CircleShape2D
	radius = circle_shape.radius if circle_shape else screen_size.x / 2

	$Timer.connect('timeout', spawn_bacteria)


func spawn_bacteria() -> void:
	var bacteria = bacteria_scene.instantiate()

	var random_angle = randf() * 2 * PI
	var random_radius = sqrt(randf()) * radius
	
	var random_position = center + Vector2(
		cos(random_angle) * random_radius,
		sin(random_angle) * random_radius
	)
	
	bacteria.global_position = random_position


	add_child(bacteria)
	print('spawn bacteria')
