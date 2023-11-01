extends HBoxContainer

var itemId = ""
var data = {}

func _ready():
	pass

func set_detail(pItemId, pData):
	itemId = pItemId
	data = pData
	
	get_node("ItemTitle/Name").set_text(data["name"])
	get_node("ItemTitle/Description").set_text("Description placeholder")
	get_node("ItemDetails/Health").set_text(str("Health: ", data["max-health"]))
	get_node("ItemDetails/Attack").set_text(str("Attack: ", data["attack"]))
	get_node("ItemDetails/Range").set_text("Range placeholder (not sure how to do this yet)")
	get_node("ItemDetails/DeathEffect").set_text("Death effect placeholder (think maybe I need to add descriptor into the json file?)")
	get_node("ItemDetails/VictoryEffect").set_text("Victory effect placeholder")
	get_node("ItemImage").set_texture(load(data["image"]))
