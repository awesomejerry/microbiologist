extends Node2D

var stat
var game_over
var elapsed_time = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	stat = find_child("Stat")
	game_over = find_child("GameOver")

	$Timer.connect("timeout", _on_Timer_timeout)

func _on_Timer_timeout() -> void:
	var bacterias = get_tree().get_nodes_in_group("Bacteria")
	if (bacterias.size() == 0):
		game_over.set_time_and_show(elapsed_time)

func _process(delta: float) -> void:
	elapsed_time += delta
	stat.set_time(elapsed_time)
