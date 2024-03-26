extends HBoxContainer

@onready var infoName = %Name
@onready var infoDescription = %Description
@onready var infoHealth = %Health
@onready var infoAttack = %Attack
@onready var infoRange = %Range
@onready var infoTurnEffect = %TurnEffect
@onready var infoDeathEffect = %DeathEffect
@onready var infoVictoryEffect = %VictoryEffect
@onready var infoUnusedEffect = %UnusedEffect
@onready var infoCost = %Cost
@onready var infoImage = %ItemImage

var data = {}

func set_detail(pData : Dictionary) -> void:
	data = pData
	
	infoName.set_text(data["name"])
	infoDescription.set_text("Description placeholder")
	infoHealth.set_text(str("Health: ", data["max-health"]))
	infoAttack.set_text(str("Attack: ", data["attack"]))
	infoRange.set_text(str("Range: ", data["range-desc"]))
	infoDeathEffect.set_text("Death effect placeholder (think maybe I need to add descriptor into the json file?)")
	infoVictoryEffect.set_text("Victory effect placeholder")
	infoCost.set_text(str("Cost: ", data["cost"]))
	infoImage.set_texture(load(data["image"]))
	
func get_data() -> Dictionary:
	return data
