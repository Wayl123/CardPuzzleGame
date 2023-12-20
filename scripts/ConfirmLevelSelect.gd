extends ConfirmationDialog

func _ready():
	connect("confirmed", Callable(self, "_on_close"))
	connect("canceled", Callable(self, "_on_close"))
	
func _on_close():
	queue_free()
