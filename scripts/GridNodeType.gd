extends Panel

@onready var content = %Content

@export var nodeType: String
@export var unitId: String
@export var fogGroup: String

func _ready() -> void:
	_set_node()

func _set_node() -> void:
	if fogGroup:
		content.add_to_group("Fog")
	
	match nodeType:
		"boulder":
			content.set_disabled(true)
			content.set_texture_normal(load("res://image/map/boulder_wall.png"))
		"enemy":
			content.set_disabled(true)
			content.add_unit_by_id(unitId)
			content.add_to_group("TargetableNode")
		"player":
			content.add_unit_by_id(unitId)
			content.add_to_group("TargetableNode")
		"shop":
			content.set_disabled(true)
			content.add_unit_by_id(unitId)
		"portal":
			content.set_disabled(true)
			content.add_unit_by_id("X")
		_:
			content.add_to_group("TargetableNode")
			
	if fogGroup:
		content.set_disabled(true)
		content.set_texture_normal(load("res://image/fog.png"))
		content.add_to_group(fogGroup)
		content.remove_from_group("TargetableNode")
		for fogCovered in content.get_children():
			fogCovered.set_z_index(-1)
