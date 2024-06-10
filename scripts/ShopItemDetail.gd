extends HBoxContainer

@onready var infoName = %Name
@onready var infoDescription = %Description
@onready var infoHealth = %Health
@onready var infoAttack = %Attack
@onready var infoRange = %Range
@onready var infoDeathEffect = %DeathEffect
@onready var infoVictoryEffect = %VictoryEffect
@onready var infoCost = %Cost
@onready var infoImage = %ItemImage

var data = {}

func set_detail(pData : Dictionary) -> void:
	data = pData
	
	infoName.text = data["name"]
	infoDescription.text = "Description placeholder"
	infoHealth.text = str("Health: ", data["max-health"])
	infoAttack.text = str("Attack: ", data["attack"])
	infoRange.text = str("Range: ", data["range-desc"])
	#infoDeathEffect.set_text(str("On Death: ", data["on-death-desc"]))
	infoCost.text = str("Cost: ", data["cost"])
	infoImage.texture = load(data["image"])
	
func get_data() -> Dictionary:
	return data
