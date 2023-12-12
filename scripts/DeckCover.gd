extends Node2D

func _ready() -> void:
	_set_transform()
	pass

func _set_transform() -> void:
	var localTransform = Transform2D(Vector2(0.85, -0.3), Vector2(0, 0.85), get_position() + Vector2(3, 4))
	
	set_transform(localTransform)
