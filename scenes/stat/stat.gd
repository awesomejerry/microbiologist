extends Node2D


var main_c_elegans = null

func _ready() -> void:
	main_c_elegans = get_tree().get_root().find_child("C_Elegans_Main", true, false)

func set_time(time: float) -> void:
	$VBoxContainer/HBoxContainer/Time.text = "%d" % time

func _process(delta: float) -> void:
	if (main_c_elegans):
		$VBoxContainer/HBoxContainer2/BacteriaCount.text = "%d" % main_c_elegans.eaten_bacteria
		$VBoxContainer/HBoxContainer3/PhaseCount.text = "%d" % main_c_elegans.growth_phase
