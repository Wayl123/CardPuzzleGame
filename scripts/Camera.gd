extends Camera2D

var zoom_min = Vector2(0.2, 0.2)
var zoom_max = Vector2(2, 2)
var zoom_speed = Vector2(5, 5)
var move_speed = 500

func _process(delta : float) -> void:
	if Input.is_action_just_pressed("ZoomOut"):
		if zoom > zoom_min:
			zoom -= zoom_speed * delta
	if Input.is_action_just_pressed("ZoomIn"):
		if zoom < zoom_max:
			zoom += zoom_speed * delta
	if Input.is_action_pressed("RightButton"):
		position += Vector2(move_speed, 0) * delta
	if Input.is_action_pressed("LeftButton"):
		position -= Vector2(move_speed, 0) * delta
	if Input.is_action_pressed("DownButton"):
		position += Vector2(0, move_speed) * delta
	if Input.is_action_pressed("UpButton"):
		position -= Vector2(0, move_speed) * delta
