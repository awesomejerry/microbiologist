extends Node2D

var background_size = Vector2(200, 200)
var minimap_size = Vector2(200, 200)
var ratio = 0

var marker_bacteria_scene = preload("res://scenes/minimap/marker_bacteria.tscn")
var marker_bacterias = []

var marker_celegans_scene = preload("res://scenes/minimap/marker_celegans.tscn")
var marker_celeganses = []

func _ready() -> void:
	var petri_dish = get_tree().get_root().find_child("PetriDish", true, false)
	if petri_dish:
		background_size = petri_dish.find_child("Background").get_rect().size
	minimap_size = find_child("ColorRect").get_rect().size
	ratio = background_size / minimap_size

	$Timer.connect("timeout", _on_Timer_timeout)

func _on_Timer_timeout() -> void:
	var bacterias = get_tree().get_nodes_in_group("Bacteria")
	for marker_bacteria in marker_bacterias:
		marker_bacteria.hide()
		marker_bacteria.queue_free()
	marker_bacterias.clear()
	for bacteria in bacterias:
		var marker_bacteria = marker_bacteria_scene.instantiate()
		marker_bacterias.append(marker_bacteria)
		add_child(marker_bacteria)
		marker_bacteria.position = bacteria.position / ratio

	var celegans = get_tree().get_nodes_in_group("C_Elegans")
	for marker_celegans in marker_celeganses:
		marker_celegans.hide()
		marker_celegans.queue_free()
	marker_celeganses.clear()
	for c in celegans:
		var marker_celegans = marker_celegans_scene.instantiate()
		marker_celeganses.append(marker_celegans)
		add_child(marker_celegans)
		marker_celegans.position = c.points[0] / ratio
		if (c.is_main):
			marker_celegans.find_child("ColorRect").color = Color(1, 0, 0)
			marker_celegans.find_child("ColorRect").get_rect().size = Vector2(12, 12)
		else:
			marker_celegans.find_child("ColorRect").color = Color(0, 0, 1)