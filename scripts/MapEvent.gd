extends Control

var groupNum = 1

func check_enemy_cleared():
	var enemies = get_tree().get_nodes_in_group("CurrentEnemy")
	if not enemies:
		for fog in get_tree().get_nodes_in_group(str("Fog", groupNum)):
			fog.set_texture_normal(null)
			
			fog.remove_from_group("Fog")
			fog.remove_from_group(str("Fog", groupNum))
			
			if fog.get_child_count() == 0:
				fog.set_disabled(false)
				fog.add_to_group("TargetableNode")
			else:
				for fogCovered in fog.get_children():
					fogCovered.set_z_index(0)
					if fogCovered.is_in_group("Enemy"):
						fogCovered.activate_enemy()
						fog.add_to_group("TargetableNode")
				
		for player in get_tree().get_nodes_in_group("PlayerUnits"):
			player.on_effect("victory")
			
		groupNum += 1
