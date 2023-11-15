extends Node2D

@onready var ap = %AnimationPlayer
@onready var labelContainer = %LabelContainer
@onready var label = %Label

var HEIGHT = 100
var SPREAD = 50

func _ready():
	pass

func set_values_and_animate(value, startPos):
	label.text = str(value)
	ap.play("RiseAndFade")
	
	var tween = get_tree().create_tween()
	var endPos = Vector2(randf_range(-SPREAD, SPREAD), -HEIGHT) + startPos
	var tweenLength = ap.get_animation("RiseAndFade").length
	
	tween.tween_property(labelContainer, "position", endPos, tweenLength).from(startPos)

func remove():
	queue_free()
