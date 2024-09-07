extends TextureRect

signal on_request_start

func _ready() -> void:
  _get_animated_texture().pause = true

func _get_animated_texture() -> AnimatedTexture:
  return self.texture as AnimatedTexture

func _on_button_pressed() -> void:
  $Button.hide()
  $Timer.connect("timeout", _on_animation_finished)
  $Timer.start()
  _get_animated_texture().current_frame = 0
  _get_animated_texture().pause = false

func _on_animation_finished() -> void:
  if (_get_animated_texture().current_frame == _get_animated_texture().frames - 1):
    $Timer.disconnect("timeout", _on_animation_finished)
    $Timer.stop()
    on_request_start.emit()
