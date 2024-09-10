extends Node2D

class_name Bacteria

@export var texture: Texture = load("res://assets/bacteria/1.png")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$TextureRect.texture = texture


func eaten() -> void:
	queue_free()
