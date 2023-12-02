extends Node2D

@onready var ap = %AnimationPlayer
@onready var labelContainer = %LabelContainer
@onready var label = %Label

var HEIGHT = 64
var SPREAD = 64

func set_values_and_animate(value : float, startPos : Vector2) -> void:
	label.text = str(value)
	ap.play("RiseAndFade")
	
	var tween = get_tree().create_tween()
	var endPos = Vector2(randf_range(-SPREAD, SPREAD), -HEIGHT) + startPos
	var tweenLength = ap.get_animation("RiseAndFade").length
	
	tween.tween_property(labelContainer, "position", endPos, tweenLength).from(startPos)

func remove() -> void:
	queue_free()
