extends Control

var groupNum = 1

func check_enemy_cleared():
	var enemies = get_tree().get_nodes_in_group("CurrentEnemy")
	if not enemies:
		for fog in get_tree().get_nodes_in_group(str("Fog", groupNum)):
			fog.set_texture_normal(null)
			if fog.get_child_count() == 0:
				fog.set_disabled(false)
			else:
				for fogCovered in fog.get_children():
					fogCovered.set_z_index(1)
				
			if fog.has_node("Enemy"):
				fog.get_node("Enemy").activate_enemy()
				
		groupNum += 1
