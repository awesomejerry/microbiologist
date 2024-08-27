extends Line2D

var speed = 200
var distance_constraint = 5

func constraint_distance(point: Vector2, anchor: Vector2, distance: float) -> Vector2:
	return ((point - anchor).normalized() * distance) + anchor

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in 50:
		add_point(Vector2.ZERO)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var target_position = get_local_mouse_position()
	for i in points.size():
		if (i == 0):
			var direction = (target_position - points[0]).normalized()
			points[0] += direction * speed * delta
			# points[0] = points[0].lerp(get_local_mouse_position(), speed * delta)
			# points[0] = get_local_mouse_position()
		else:
			points[i] = constraint_distance(points[i], points[i - 1], distance_constraint)
