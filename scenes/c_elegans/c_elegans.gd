extends Line2D

class_name C_Elegans

var speed = 200.0
var distance_constraint = 5.0

var original_width = 50.0
var original_distance_constraint = 5.0

var growth_phase = 0

var eaten_bacteria = 0

var growth_width_factor = [1.5, 2.5, 4, 6]
var growth_step = [10, 20, 40, 80]
var growth_length_factor = [1.3, 1.8, 2.5, 3.5]

var is_main = false
var nearest_bacteria = null
var last_movement = Vector2.ZERO

func constraint_distance(point: Vector2, anchor: Vector2, distance: float) -> Vector2:
	return ((point - anchor).normalized() * distance) + anchor

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	original_width = width
	original_distance_constraint = distance_constraint
	add_to_group("C_Elegans")
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
	elif has_node("SearchTimer"):
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
	var collidedNode = area.get_parent()
	if (collidedNode is Bacteria):
		collidedNode.eaten()
		grow()
	elif (collidedNode is C_Elegans && collidedNode != self):
		if (collidedNode.growth_phase < growth_phase):
			print("Spawn new c.elegans with smaller growth_phase?")


func _calculate_width():
	var total_steps = growth_step.reduce(func(acc, val): return acc + val, 0)
	var current_step = min(eaten_bacteria, total_steps)
	var progress = float(current_step) / total_steps
	var target_width = original_width * growth_width_factor[-1]
	return lerp(original_width, target_width, progress)
	

func _calculate_distance_constraint():
	var total_steps = growth_step.reduce(func(acc, val): return acc + val, 0)
	var current_step = min(eaten_bacteria, total_steps)
	var progress = float(current_step) / total_steps
	var target_distance_constraint = original_distance_constraint * growth_length_factor[-1]
	return lerp(original_distance_constraint, target_distance_constraint, progress)

func grow() -> void:
	eaten_bacteria += 1
	width = _calculate_width()
	distance_constraint = _calculate_distance_constraint()
	if (eaten_bacteria > growth_step[growth_phase]):
		growth_phase = min(growth_phase + 1, growth_step.size() - 1)
