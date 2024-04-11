extends Panel

signal pressed

func _process(delta):
	if Rect2(Vector2(), size).has_point(get_local_mouse_position()) and Input.is_action_just_pressed("LeftMouse"):
		pressed.emit()
