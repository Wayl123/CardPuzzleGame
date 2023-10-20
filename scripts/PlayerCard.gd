extends NinePatchRect

func _ready():
	connect("mouse_entered", Callable(self, "_on_mouse_entered"))
	connect("mouse_exited", Callable(self, "_on_mouse_exited"))

func _process(delta):
	pass

func _on_mouse_entered():
	var cardPosition = get_position()
	cardPosition.y -= 128
	set_position(cardPosition)
	
func _on_mouse_exited():
	var cardPosition = get_position()
	cardPosition.y += 128
	set_position(cardPosition)
