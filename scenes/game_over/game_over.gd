extends Node2D

signal on_request_restart

func set_time_and_show(time: float) -> void:
	show()
	$ColorRect/VBoxContainer/HBoxContainer/Time.text = "%d" % time


func _on_button_pressed() -> void:
	on_request_restart.emit()
