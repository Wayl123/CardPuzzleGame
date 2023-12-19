extends NinePatchRect

func set_data(pData : Dictionary) -> void:
	get_node("TooltipItems/Name").set_text(pData["name"])
	get_node("TooltipItems/Health").set_text(str("Health: ", pData["health"], "/", pData["max-health"]))
	get_node("TooltipItems/Attack").set_text(str("Attack: ", pData["attack"]))
