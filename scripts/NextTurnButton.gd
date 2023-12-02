extends Button

var groupNum = 1

func _ready() -> void:
	connect("pressed", Callable(self, "_on_button_pressed"))

func _on_button_pressed() -> void:
	var data
	var targetPos
	var targetGlobalPos
	
	for player in get_tree().get_nodes_in_group("PlayerUnits"):
		data = player.get_data()
		for aRange in data["range"]:
			targetPos = Vector2(aRange[0], aRange[1]) * 128
			targetGlobalPos = player.get_global_position() + targetPos
			for targetNode in get_tree().get_nodes_in_group("TargetableNode"):
				if targetNode.get_global_position() == targetGlobalPos:
					for targetChild in targetNode.get_children():
						if targetChild.is_in_group("CurrentEnemy"):
							targetChild.take_damage(data["attack"])
		player.lock_player()
						
	for enemy in get_tree().get_nodes_in_group("CurrentEnemy"):
		data = enemy.get_data()
		for aRange in data["range"]:
			targetPos = Vector2(aRange[0], aRange[1]) * 128
			targetGlobalPos = enemy.get_global_position() + targetPos
			for targetNode in get_tree().get_nodes_in_group("TargetableNode"):
				if targetNode.get_global_position() == targetGlobalPos:
					for targetChild in targetNode.get_children():
						if targetChild.is_in_group("PlayerUnits"):
							targetChild.take_damage(data["attack"])
