extends NinePatchRect

@onready var infoName = %Name
@onready var infoHealth = %Health
@onready var infoAttack = %Attack

var data = {}

func _ready() -> void:
	_populate_data()
	
func _process(delta : float) -> void:
	if not Rect2(Vector2(), size).has_point(get_local_mouse_position()):
		if not get_tree().has_group("ActiveInfoBox"):
			if get_tree().has_group("RangeDisplay"):
				for rangeNode in get_tree().get_nodes_in_group("RangeDisplay"):
					rangeNode.queue_free()
		queue_free()
		
func _input(event : InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if get_parent().has_node("Enemy"):
			get_parent().get_node("Enemy").emit_signal("pressed")
		if get_parent().has_node("Player"):
			get_parent().get_node("Player").emit_signal("pressed")
	
func _populate_data() -> void:
	infoName.set_text(data["name"])
	infoHealth.set_text(str("Health: ", data["health"], "/", data["max-health"]))
	infoAttack.set_text(str("Attack: ", data["attack"]))

func set_data(pData : Dictionary) -> void:
	data = pData
