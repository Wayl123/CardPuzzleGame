extends NinePatchRect

var DRAGPREVIEW = preload("res://scene/drag_preview.tscn")
var PLAYER = preload("res://scene/player.tscn")

var data = {}

func init(pData):
	data = pData

func _ready():
	connect("mouse_entered", Callable(self, "_on_mouse_entered"))
	connect("mouse_exited", Callable(self, "_on_mouse_exited"))
	
	add_to_group("PlayerUnits")
	_data_init()

func _on_mouse_entered():
	var cardPosition = get_global_position()
	if cardPosition.y >= get_viewport().size.y - get_size().y + 128:
		cardPosition.y -= 128
	set_global_position(cardPosition)
	
func _on_mouse_exited():
	var cardPosition = get_global_position()
	if cardPosition.y < get_viewport().size.y - get_size().y + 128:
		cardPosition.y += 128
	set_global_position(cardPosition)

func _get_drag_data(_pos):
	var dataOut = {}
	
	dataOut["origin_node"] = get_parent()
	dataOut["origin_child"] = self
	dataOut["origin_data"] = data
	
	var dragPreview = DRAGPREVIEW.instantiate()
	dragPreview.set_texture(load(data["image"]))
	add_child(dragPreview)
	
	return dataOut

func _data_init():
	get_node("CardLayout/CardTitle/TitleBox/Name").set_text(data["name"])
	get_node("CardLayout/CardImageMargin/CardImage").set_texture(load(data["image"]))
	get_node("CardLayout/CardDetail/CardDetails/Health").set_text(str("Health: ", data["health"], "/", data["max-health"]))
	get_node("CardLayout/CardDetail/CardDetails/Attack").set_text(str("Attack: ", data["attack"]))
	get_node("CardLayout/CardDetail/CardDetails/EffectBox/EffectSimplified").set_text("Effect Placeholder")
