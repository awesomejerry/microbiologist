extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Timer.connect('timeout', _grow)

func _grow():
	print('grow')
	$C_Elegans_Main.grow()
