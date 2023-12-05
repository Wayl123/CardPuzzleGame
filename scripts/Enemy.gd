extends "res://scripts/UnitCard.gd"

func _ready() -> void:
	super()
	
	add_to_group("Enemy")
	
	activate_enemy()

func activate_enemy() -> void:
	if not get_parent().is_in_group("Fog"):
		add_to_group("CurrentEnemy")
