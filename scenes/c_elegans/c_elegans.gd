extends Line2D

var speed = 200
var distance_constraint = 5

var is_main = false
var nearest_bacteria = null
var last_movement = Vector2.ZERO

func constraint_distance(point: Vector2, anchor: Vector2, distance: float) -> Vector2:
	return ((point - anchor).normalized() * distance) + anchor

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("CElegans")
	for i in 50:
		add_point(Vector2.ZERO)

	if has_node("Camera2D"):
		is_main = true

	if has_node("SearchTimer"):
		$SearchTimer.connect('timeout', _get_nearest_bacteria)

func _search_for_nearest_bacteria():
	if not $SearchTimer.is_stopped():
		return
	$SearchTimer.start()

func _get_nearest_bacteria():
	var min_distance = INF
	for bacteria in get_tree().get_nodes_in_group("Bacteria"):
		var distance = points[0].distance_to(bacteria.global_position)
		if distance < min_distance:
			min_distance = distance
			nearest_bacteria = bacteria

func map_range(x, in_min, in_max, out_min, out_max):
	return (x - in_min) / (in_max - in_min) * (out_max - out_min) + out_min

func _get_movement(from: Vector2, to: Vector2, delta: float) -> Vector2:
	var direction = (to - from).normalized()
	return direction * speed * delta

func _process(delta: float) -> void:
	var target_position = Vector2.ZERO
	if (is_main):
		target_position = get_local_mouse_position()
	else:
		if (nearest_bacteria && is_instance_valid(nearest_bacteria)):
			target_position = nearest_bacteria.global_position
		else:
			_search_for_nearest_bacteria()
			target_position = points[0] + last_movement

	for i in points.size():
		if (i == 0):
			var movement = _get_movement(points[0], target_position, delta)
			points[0] += movement
			last_movement = movement

			# points[0] = points[0].lerp(get_local_mouse_position(), 5 * delta)
			# points[0] = get_local_mouse_position()

	  # move head/collision
			$Area2D.position = points[0]

			if (is_main):
				$Camera2D.position = $Area2D.position
		else:
			points[i] = constraint_distance(points[i], points[i - 1], distance_constraint)

	if (is_main):
		var ride_point_index = 10
		$Node2D.global_position = points[ride_point_index]
		$Node2D.rotation = atan2(points[ride_point_index + 1].y - points[ride_point_index].y, points[ride_point_index + 1].x - points[ride_point_index].x)


func _on_area_2d_area_entered(area: Area2D) -> void:
	if (area.get_parent() is Bacteria):
		area.get_parent().eaten()
		grow()

func grow() -> void:
	width += 20
	distance_constraint += 0.2
