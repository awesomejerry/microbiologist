extends Node2D

signal on_request_restart

var stat
var game_over
var elapsed_time = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	stat = find_child("Stat")
	game_over = find_child("GameOver")
	game_over.connect('on_request_restart', _on_request_restart)

	$Timer.connect("timeout", _on_Timer_timeout)

func _on_Timer_timeout() -> void:
	var bacterias = get_tree().get_nodes_in_group("Bacteria")
	if (bacterias.size() == 0):
		game_over.set_time_and_show(elapsed_time)
		$Timer.paused = true

func _process(delta: float) -> void:
	elapsed_time += delta
	stat.set_time(elapsed_time)

func _on_request_restart() -> void:
	on_request_restart.emit()