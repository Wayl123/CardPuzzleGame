extends Panel

@onready var infoName = %Name
@onready var infoImage = %CardImage
@onready var infoDetail = %CardDetail

var DRAGPREVIEW = preload("res://scene/drag_preview.tscn")
var PLAYER = preload("res://scene/player.tscn")

var data = {}

func _ready() -> void:
	connect("mouse_entered", Callable(self, "_on_mouse_entered"))
	connect("mouse_exited", Callable(self, "_on_mouse_exited"))
	
	_data_init()
	add_to_group("PlayerCards")

func _on_mouse_entered() -> void:
	var cardPosition = global_position
	if cardPosition.y >= get_viewport().size.y - size.y + 128:
		cardPosition.y -= 128
	global_position = cardPosition
	
func _on_mouse_exited() -> void:
	var cardPosition = global_position
	if cardPosition.y < get_viewport().size.y - size.y + 128:
		cardPosition.y += 128
	global_position = cardPosition

func _get_drag_data(_pos : Vector2) -> Variant:
	var dataOut = {}
	
	dataOut["origin_node"] = get_parent()
	dataOut["origin_child"] = self
	dataOut["origin_data"] = data
	
	var dragPreview = DRAGPREVIEW.instantiate()
	dragPreview.texture = load(data["image"])
	add_child(dragPreview)
	
	return dataOut

func _data_init() -> void:
	infoName.text = str("[b]", data["name"], "[/b]")
	infoImage.texture = load(data["image"])
	infoDetail.text += str("[b]Health:[/b] ", data["health"], "/", data["max-health"], "\n")
	infoDetail.text += str("[b]Attack:[/b] ", data["attack"], "\n")
	
	if data.has("on-death-desc"):
		infoDetail.text += str("[b]On Death:[/b] ", data["on-death-desc"], "\n")
	if data.has("on-victory-desc"):
		infoDetail.text += str("[b]On Victory:[/b] ", data["on-victory-desc"], "\n")
	if data.has("on-all-kill-desc"):
		infoDetail.text += str("[b]On All Kill:[/b] ", data["on-all-kill-desc"], "\n")
	if data.has("on-completion-desc"):
		infoDetail.text += str("[b]On Completion:[/b] ", data["on-completion-desc"], "\n")
	if data.has("on-hand-completion-desc"):
		infoDetail.text += str("[b]On Hand Completion:[/b] ", data["on-hand-completion-desc"], "\n")
	if data.has("on-fail-desc"):
		infoDetail.text += str("[b]On Fail:[/b] ", data["on-fail-desc"], "\n")
	
func set_data(pData : Dictionary) -> void:
	data = pData
	if data.has("rotation"):
		while abs(data["rotation"]) > 0.000001:
			data["rotation"] = fmod(data["rotation"] + 90, 360)
			for rangeIndex in data["range"].size():
				var aRange = data["range"][rangeIndex]
				data["range"][rangeIndex] = [-aRange[1], aRange[0]]
	else:
		data["rotation"] = 0
	
func get_deck(success : bool) -> Array:
	var deckCards = []
	
	if success:
		if data.has("on-hand-completion"):
			var onCompletion = data["on-hand-completion"]
			
			if onCompletion.has("deck"):
				deckCards += onCompletion["deck"]
		elif data.has("on-completion"): #default to completion effect if no on hand completion effect
			var onCompletion = data["on-completion"]
			
			if onCompletion.has("deck"):
				deckCards += onCompletion["deck"]
	else:
		if data.has("on-fail"):
			var onFail = data["on-fail"]
			
			if onFail.has("deck"):
				deckCards += onFail["deck"]
				
	return deckCards
