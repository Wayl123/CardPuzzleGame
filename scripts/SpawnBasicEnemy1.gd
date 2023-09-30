extends "res://scripts/GridContent.gd"

func _ready():
	var basicEnemy1 = get_node("Enemy/BasicEnemy1")
	basicEnemy1.set_visible(true)
	basicEnemy1.set_disabled(false)
