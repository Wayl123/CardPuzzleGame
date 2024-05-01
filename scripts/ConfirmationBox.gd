extends ConfirmationDialog

func _ready() -> void:
	connect("confirmed", Callable(self, "_on_close"))
	connect("canceled", Callable(self, "_on_close"))
	
func _on_close() -> void:
	queue_free()
