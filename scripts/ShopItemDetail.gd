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
	infoDescription.text = data["desc"]
	infoHealth.text = str("Health: ", data["max-health"])
	infoAttack.text = str("Attack: ", data["attack"])
	infoRange.text = str("Range: ", data["range-desc"])
	infoCost.text = str("Cost: ", data["cost"])
	infoImage.texture = load(data["image"])
	
	if data.has("on-death-desc"):
		infoDeathEffect.text = str("On Death: ", data["on-death-desc"])
	if data.has("on-victory-desc"):
		infoVictoryEffect.text = str("On Victory: ", data["on-victory-desc"])
	
func get_data() -> Dictionary:
	return data
