extends HBoxContainer

@onready var infoName = %Name
@onready var infoDescription = %Description
@onready var infoHealth = %Health
@onready var infoAttack = %Attack
@onready var infoRange = %Range
@onready var infoDeathEffect = %DeathEffect
@onready var infoVictoryEffect = %VictoryEffect
@onready var infoAllKillEffect = %AllKillEffect
@onready var infoCompletionEffect = %CompletionEffect
@onready var infoHandCompletionEffect = %HandCompletionEffect
@onready var infoFailEffect = %FailEffect
@onready var infoCost = %Cost
@onready var infoImage = %ItemImage

var data = {}

func set_detail(pData : Dictionary) -> void:
	data = pData
	
	infoName.text = str("[b]", data["name"], "[/b]")
	infoDescription.text = data["desc"]
	infoHealth.text = str("[b]Health:[/b] ", data["max-health"])
	infoAttack.text = str("[b]Attack:[/b] ", data["attack"])
	infoRange.text = str("[b]Range:[/b] ", data["range-desc"])
	infoCost.text = str("[b]Cost:[/b] ", data["cost"])
	infoImage.texture = load(data["image"])
	
	if data.has("on-death-desc"):
		infoDeathEffect.text = str("[b]On Death:[/b] ", data["on-death-desc"])
	if data.has("on-victory-desc"):
		infoVictoryEffect.text = str("[b]On Victory:[/b] ", data["on-victory-desc"])
	if data.has("on-all-kill-desc"):
		infoAllKillEffect.text = str("[b]On All Kill:[/b] ", data["on-all-kill-desc"])
	if data.has("on-completion-desc"):
		infoCompletionEffect.text = str("[b]On Completion:[/b] ", data["on-completion-desc"])
	if data.has("on-hand-completion-desc"):
		infoHandCompletionEffect.text = str("[b]On Hand Completion:[/b] ", data["on-hand-completion-desc"])
	if data.has("on-fail-desc"):
		infoAllKillEffect.text = str("[b]On Fail:[/b] ", data["on-fail-desc"])
	
func get_data() -> Dictionary:
	return data
