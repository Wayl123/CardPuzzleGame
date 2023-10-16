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

func init(data):
	get_node("InfoList/InfoBanner/InfoTitle/Name").set_text(data["name"])
	get_node("InfoList/InfoBanner/InfoTitle/Description").set_text("Description placeholder")
	get_node("InfoList/InfoBanner/Image").set_texture(load(data["image"]))
	get_node("InfoList/Health").set_text(str("Health: ", data["health"], "/", data["max-health"]))
	get_node("InfoList/Attack").set_text(str("Attack: ", data["attack"]))
	get_node("InfoList/DeathEffect").set_text("Death effect placeholder")
	get_node("InfoList/VictoryEffect").set_text("")
