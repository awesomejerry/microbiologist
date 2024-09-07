extends ColorRect

signal on_enter_finished
signal on_exit_finished

func _ready() -> void:
	self.mouse_filter = Control.MOUSE_FILTER_IGNORE
	$AnimationPlayer.connect("animation_finished", _on_animation_finished)

func enter() -> void:
	self.mouse_filter = Control.MOUSE_FILTER_PASS
	$AnimationPlayer.play("close")

func exit() -> void:
	$AnimationPlayer.play("open")
	self.mouse_filter = Control.MOUSE_FILTER_IGNORE

func _on_animation_finished(anim_name: String) -> void:
	if anim_name == "close":
		on_enter_finished.emit()
	if anim_name == "open":
		on_exit_finished.emit()
