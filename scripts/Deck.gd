extends TextureButton

@onready var deckCover = %DeckCover
@onready var deckLevel = %DeckLevel

var DRAGPREVIEW = preload("res://scene/drag_preview.tscn")

var data = {}

func set_data(pData : Dictionary) -> void:
	data = pData

func _ready() -> void:
	_data_init()
	
func _get_drag_data(_pos : Vector2) -> Variant:
	var dataOut = {}
	
	if data:
		dataOut["origin_node"] = get_parent()
		dataOut["origin_child"] = self
		dataOut["origin_data"] = data
	
		var dragPreview = DRAGPREVIEW.instantiate()
		dragPreview.set_texture(get_texture_normal())
		dragPreview.set_modulate(deckCover.get_modulate())
		add_child(dragPreview)
	
	return dataOut
	
func update_data(pData : Dictionary) -> void:
	data = pData
	
	_set_deck_cover()
	
func _data_init() -> void:
	deckCover.set_transform_scale(get_size().x / 128)
	deckCover.set_position(deckCover.get_position() + (get_size() * 0.5))
	
	_set_deck_cover()
		
func _set_deck_cover() -> void:
	if data:
		set_modulate(Color(1, 1, 1, 1))
		if data["clear"]:
			deckCover.set_modulate(Color(0, 1, 0, 0.25))
		else:
			deckCover.set_modulate(Color(1, 0, 0, 0.25))
		deckLevel.set_texture(load(data["level-image"]))
	else:
		set_modulate(Color(0, 0, 0, 1))
