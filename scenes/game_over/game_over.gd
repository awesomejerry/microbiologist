extends Node2D

func set_time_and_show(time: float) -> void:
	show()
	$ColorRect/VBoxContainer/HBoxContainer/Time.text = "%d" % time


func _on_button_pressed() -> void:
	get_tree().reload_current_scene()
