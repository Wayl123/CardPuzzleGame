extends Node2D

@onready var globalData = get_tree().get_first_node_in_group("GlobalData")
@onready var canvasLayer = %CanvasLayer

var TUTORIAL = preload("res://scene/tutorial.tscn")

func _ready() -> void:
	_play_tutorial()

func _play_tutorial() -> void:
	if not globalData.get_played():
		canvasLayer.add_child(TUTORIAL.instantiate())
