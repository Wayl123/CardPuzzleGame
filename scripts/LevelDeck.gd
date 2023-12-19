extends "res://scripts/Deck.gd"

func _ready():
	super()
	
	connect("pressed", Callable(self, "_on_button_pressed"))

func _on_button_pressed() -> void:
	get_parent().return_deck(self, data)

func update_data(pData : Dictionary) -> void:
	data = pData
	
	_set_deck_cover()
