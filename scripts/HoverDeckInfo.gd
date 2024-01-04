extends MarginContainer

@onready var infoContent = %Content

var textContent = ""

func set_text_content(pData : Dictionary) -> void:
	textContent = str(
		"Gold: ", pData["items"]["gold"], "\n",
		"Honour: ", pData["items"]["honour"], "\n",
		"Research: ", pData["items"]["research"], "\n",
		"Soul: ", pData["items"]["soul"], "\n",
		"Scrap: ", pData["items"]["scrap"], "\n",
		"Cards: ", pData["cards"].size()
	)

func _ready() -> void:
	_populate_data()
	
func _populate_data() -> void:
	infoContent.set_text(textContent)
