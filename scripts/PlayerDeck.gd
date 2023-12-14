extends NinePatchRect

@onready var deckCover = %DeckCover
@onready var deckLevel = %DeckLevel

var DRAGPREVIEW = preload("res://scene/drag_preview.tscn")

var data = {}
var deckType : int = 1:
	set = _set_deck_type

func init(pData : Dictionary) -> void:
	data = pData

func _ready() -> void:
	connect("mouse_entered", Callable(self, "_on_mouse_entered"))
	connect("mouse_exited", Callable(self, "_on_mouse_exited"))
	
	_data_init()
	
func _on_mouse_entered() -> void:
	if deckType == 1:
		var deckPosition = get_global_position()
		if deckPosition.y >= get_viewport().size.y - get_size().y + 128:
			deckPosition.y -= 128
		set_global_position(deckPosition)
	
func _on_mouse_exited() -> void:
	if deckType == 1:
		var deckPosition = get_global_position()
		if deckPosition.y < get_viewport().size.y - get_size().y + 128:
			deckPosition.y += 128
		set_global_position(deckPosition)
	
func _get_drag_data(_pos : Vector2) -> Variant:
	var dataOut = {}
	
	dataOut["origin_node"] = get_parent()
	dataOut["origin_child"] = self
	dataOut["origin_data"] = data
	
	var dragPreview = DRAGPREVIEW.instantiate()
	dragPreview.set_texture(get_texture())
	dragPreview.set_modulate(deckCover.get_modulate())
	add_child(dragPreview)
	
	return dataOut
	
func _data_init() -> void:
	deckCover.set_transform_scale(get_size().x / 128)
	if deckType == 1:
		deckCover.set_position(deckCover.get_position() + (get_size() * 0.5))
	
	if data:
		if data["clear"]:
			deckCover.set_modulate(Color(0, 1, 0, 0.25))
		else:
			deckCover.set_modulate(Color(1, 0, 0, 0.25))
		deckLevel.set_texture(load(data["level-image"]))
	else:
		set_modulate(Color(0, 0, 0, 1))

func _set_deck_type(value : int) -> void:
	deckType = value
