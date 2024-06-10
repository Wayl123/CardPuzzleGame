extends "res://scripts/Deck.gd"

var HOVERDECKINFO = preload("res://scene/hover_deck_info.tscn")

func _ready() -> void:
	super()
	
	connect("mouse_entered", Callable(self, "_on_mouse_entered"))
	connect("mouse_exited", Callable(self, "_on_mouse_exited"))
	
func _on_mouse_entered() -> void:
	if not has_node("HoverDeckInfo"):
		var deckPosition = global_position
		if deckPosition.y >= get_viewport().size.y - size.y + 128:
			deckPosition.y -= 128
		global_position = deckPosition
			
		var hoverDeckInfo = HOVERDECKINFO.instantiate()
		
		hoverDeckInfo.visible = false
		hoverDeckInfo.set_text_content(data)
		hoverDeckInfo.position = Vector2(size.x, 0)
		hoverDeckInfo.add_to_group("ActiveHoverDeckInfo")
		
		add_child(hoverDeckInfo)
	
		await get_tree().create_timer(0.2).timeout
		
		if is_instance_valid(hoverDeckInfo):
			hoverDeckInfo.visible = true
	
func _on_mouse_exited() -> void:
	var deckPosition = global_position
	if deckPosition.y < get_viewport().size.y - size.y + 128:
		deckPosition.y += 128
	global_position = deckPosition
