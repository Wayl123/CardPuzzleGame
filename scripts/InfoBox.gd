extends NinePatchRect

var drag_position = null

func _ready():
	pass

func _process(delta):
	if not Rect2(Vector2(), size).has_point(get_local_mouse_position()) and Input.is_action_just_pressed("LeftMouse"):
		if has_node("../Range"):
			get_node("../Range").queue_free()
		if has_node("../Selected"):
			get_node("../Selected").queue_free()
		queue_free()
	
	if Input.is_action_pressed("LeftMouse"):
		drag_position = get_global_mouse_position() - global_position
	else:
		drag_position = null

func _input(event):
	if event is InputEventMouseMotion and drag_position != null:
		set_global_position(get_global_mouse_position() - drag_position)
