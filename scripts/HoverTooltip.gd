extends Panel

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
	
func _populate_data() -> void:
	infoName.text = data["name"]
	infoHealth.text = str("Health: ", data["health"], "/", data["max-health"])
	infoAttack.text = str("Attack: ", data["attack"])

func set_data(pData : Dictionary) -> void:
	data = pData
