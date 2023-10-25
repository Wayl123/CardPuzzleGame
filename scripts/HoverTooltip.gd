extends NinePatchRect

func init(data):
	get_node("TooltipItems/Name").set_text(data["name"])
	get_node("TooltipItems/Health").set_text(str("Health: ", data["health"], "/", data["max-health"]))
	get_node("TooltipItems/Attack").set_text(str("Attack: ", data["attack"]))
