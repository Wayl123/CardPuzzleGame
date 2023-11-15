extends Button

var groupNum = 1

func _ready():
	connect("pressed", Callable(self, "_on_button_pressed"))

func _on_button_pressed():
	var data
	
	for player in get_tree().get_nodes_in_group("PlayerUnits"):
		data = player.get_data()
		for aRange in data["range"]:
			var targetPos = Vector2(aRange[0], aRange[1]) * 128
			var targetGlobalPos = player.get_global_position() + targetPos
			for targetNode in get_tree().get_nodes_in_group("TargetableNode"):
				if targetNode.get_global_position() == targetGlobalPos:
					if targetNode.has_node("Enemy"):
						targetNode.get_node("Enemy").take_damage(data["attack"])
