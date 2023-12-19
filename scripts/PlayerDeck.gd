extends "res://scripts/Deck.gd"

func set_data(pData : Dictionary) -> void:
	data = pData

func _ready() -> void:
	super()
	
	connect("mouse_entered", Callable(self, "_on_mouse_entered"))
	connect("mouse_exited", Callable(self, "_on_mouse_exited"))
	
func _on_mouse_entered() -> void:
	var deckPosition = get_global_position()
	if deckPosition.y >= get_viewport().size.y - get_size().y + 128:
		deckPosition.y -= 128
	set_global_position(deckPosition)
	
func _on_mouse_exited() -> void:
	var deckPosition = get_global_position()
	if deckPosition.y < get_viewport().size.y - get_size().y + 128:
		deckPosition.y += 128
	set_global_position(deckPosition)
