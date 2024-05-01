extends "res://scripts/Deck.gd"

func _ready() -> void:
	super()
	
	connect("pressed", Callable(self, "_on_button_pressed"))

func _on_button_pressed() -> void:
	get_parent().return_deck(self, data)
