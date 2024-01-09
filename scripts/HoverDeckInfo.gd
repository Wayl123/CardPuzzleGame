extends MarginContainer

@onready var infoContent = %Content

var textContent = ""

func _ready() -> void:
	_populate_data()
	
func _process(delta : float) -> void:
	if not Rect2(get_parent().get_global_position(), get_parent().get_size()).has_point(get_global_mouse_position()):
		queue_free()
	
func _populate_data() -> void:
	infoContent.set_text(textContent)

func set_text_content(pData : Dictionary) -> void:
	textContent = str(
		"Gold: ", pData["items"]["gold"], "\n",
		"Honour: ", pData["items"]["honour"], "\n",
		"Research: ", pData["items"]["research"], "\n",
		"Soul: ", pData["items"]["soul"], "\n",
		"Scrap: ", pData["items"]["scrap"], "\n",
		"Cards: ", pData["cards"].size()
	)
