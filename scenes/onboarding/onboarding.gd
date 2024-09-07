extends TextureRect

@export var next_scene: PackedScene

func _on_button_pressed() -> void:
  var next_scene_instance = next_scene.instantiate()
  get_tree().root.add_child(next_scene_instance)
  queue_free()