extends Node2D

var onboarding
var circle_transition

func _ready() -> void:
	onboarding = find_child("Onboarding")
	circle_transition = find_child("CircleTransition")

	onboarding.connect("on_request_start", _on_request_start)

func _on_request_start() -> void:
	circle_transition.on_enter_finished.connect(_load_petri_dish)
	circle_transition.enter()

func _load_petri_dish() -> void:
	circle_transition.on_enter_finished.disconnect(_load_petri_dish)
	onboarding.hide()
	var petri_dish = preload("res://scenes/petri_dish/petri_dish.tscn").instantiate()
	add_child(petri_dish)
	circle_transition.exit()
