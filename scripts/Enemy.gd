extends "res://scripts/UnitCard.gd"

func _ready():
	super()
	
	add_to_group("Enemy")
	
	activate_enemy()

func activate_enemy():
	if not get_parent().is_in_group("Fog"):
		add_to_group("CurrentEnemy")
