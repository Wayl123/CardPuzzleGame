extends NinePatchRect

@onready var infoName = %Name
@onready var infoHealth = %Health
@onready var infoAttack = %Attack

var data = {}

func set_data(pData : Dictionary) -> void:
	data = pData

func _ready() -> void:
	_populate_data()
	
func _populate_data() -> void:
	infoName.set_text(data["name"])
	infoHealth.set_text(str("Health: ", data["health"], "/", data["max-health"]))
	infoAttack.set_text(str("Attack: ", data["attack"]))
