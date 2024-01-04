extends "res://scripts/Deck.gd"

var HOVERDECKINFO = preload("res://scene/hover_deck_info.tscn")

func _ready() -> void:
	super()
	
	connect("mouse_entered", Callable(self, "_on_mouse_entered"))
	connect("mouse_exited", Callable(self, "_on_mouse_exited"))
	
func _on_mouse_entered() -> void:
	if not has_node("HoverDeckInfo"):
		var deckPosition = get_global_position()
		if deckPosition.y >= get_viewport().size.y - get_size().y + 128:
			deckPosition.y -= 128
		set_global_position(deckPosition)
	
		if get_tree().has_group("ActiveHoverDeckInfo"):
			await get_tree().get_first_node_in_group("ActiveHoverDeckInfo").tree_exited
			
		var hoverDeckInfo = HOVERDECKINFO.instantiate()
		
		hoverDeckInfo.set_visible(false)
		hoverDeckInfo.set_text_content(data)
		hoverDeckInfo.set_position(Vector2(get_size().x, 0))
		hoverDeckInfo.add_to_group("ActiveHoverDeckInfo")
		
		add_child(hoverDeckInfo)
	
		await get_tree().create_timer(0.2).timeout
		
		if has_node("HoverDeckInfo") and not get_node("HoverDeckInfo").is_visible():
			get_node("HoverDeckInfo").set_visible(true)
	
func _on_mouse_exited() -> void:
	var deckPosition = get_global_position()
	if deckPosition.y < get_viewport().size.y - get_size().y + 128:
		deckPosition.y += 128
	set_global_position(deckPosition)
	
	if get_tree().has_group("ActiveHoverDeckInfo"):
		get_tree().get_first_node_in_group("ActiveHoverDeckInfo").queue_free()
