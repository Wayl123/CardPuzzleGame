extends TextureButton

var HOVERTOOLTIP = preload("res://scene/hover_tooltip.tscn")

func _ready():
	connect("mouse_entered", Callable(self, "_on_mouse_entered"))
	connect("mouse_exited", Callable(self, "_on_mouse_exited"))

func _process(delta):
	pass

func _on_mouse_entered():
	var hoverTooltip = HOVERTOOLTIP.instantiate()
	
	hoverTooltip.set_position(position)
	hoverTooltip.set_visible(false)
	
	add_child(hoverTooltip)
	
	await get_tree().create_timer(0.2).timeout
	if has_node("HoverTooltip"):
		get_node("HoverTooltip").set_visible(true)
	
func _on_mouse_exited():
	if not Rect2(Vector2(), size).has_point(get_local_mouse_position()):
		get_node("HoverTooltip").queue_free()
