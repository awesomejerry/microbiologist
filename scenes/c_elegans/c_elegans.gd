extends Line2D

class_name C_Elegans

var original_width = 50.0
var original_speed = 200.0
var original_distance_constraint = 5.0

var speed = original_speed
var distance_constraint = original_distance_constraint

var growth_phase = 0

var eaten_bacteria = 0

var growth_width_factor = [1.5, 2.5, 4, 6]
var growth_step = [10, 20, 40, 80]
var growth_length_factor = [1.3, 1.8, 2.5, 3.5]

var is_main = false
var nearest_bacteria = null
var last_movement = Vector2.ZERO

var can_be_hit = false

var area2Ds = []

func constraint_distance(point: Vector2, anchor: Vector2, distance: float) -> Vector2:
	return ((point - anchor).normalized() * distance) + anchor

func _ready() -> void:
	add_to_group("C_Elegans")
	area2Ds.append($Area2D)

	for i in 50:
		add_point(points[0])
		# var area_duplicate = $Area2D.duplicate()
		# var child_duplicate = $Area2D/CollisionShape2D.duplicate()
		# area_duplicate.add_child(child_duplicate)
		# add_child(area_duplicate)
		# area2Ds.append(area_duplicate)

	if has_node("Camera2D"):
		is_main = true
		# test eating
		# original_speed = 300
		# for i in 80:
			# grow()

	if has_node("SearchTimer"):
		$SearchTimer.connect('timeout', _get_nearest_bacteria)
	
	$HitTimer.connect('timeout', _on_hit_timer_timeout)
	$HitTimer.start()

func _on_hit_timer_timeout():
	can_be_hit = true

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
			$Area2D.position = points[0]

			if (is_main):
				$Camera2D.position = $Area2D.position
		else:
			points[i] = constraint_distance(points[i], points[i - 1], distance_constraint)
			# area2Ds[i].position = points[i]

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
		pass
		# if (collidedNode.can_be_hit && growth_phase < collidedNode.growth_phase):
			# var stolen_bacteria = (collidedNode.eaten_bacteria - eaten_bacteria) / 2
			# collidedNode.steal_bacteria_from(stolen_bacteria)
			# steal_bacteria_to(stolen_bacteria)
		# if (collidedNode.growth_phase < growth_phase && collidedNode.can_be_hit):
		# 	collidedNode.be_hit()

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
	growth_phase = growth_step.bsearch(eaten_bacteria)
	speed = original_speed - growth_phase * 10

func be_hit():
	eaten_bacteria /= 2

	var new_c_elegans = duplicate()
	new_c_elegans.points = [points[0]]
	get_tree().get_root().add_child(new_c_elegans)

	grow()
	new_c_elegans.grow()

	can_be_hit = false
	$HitTimer.start()

func steal_bacteria_from(bacteria_count: int) -> void:
	eaten_bacteria -= bacteria_count
	grow()
	can_be_hit = false
	$HitTimer.start()

func steal_bacteria_to(bacteria_count: int) -> void:
	eaten_bacteria += bacteria_count
	grow()