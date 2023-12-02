extends GPUParticles2D

@onready var timer = %Timer

func _ready() -> void:
	timer.timeout.connect(_on_timer_timeout)

func _on_timer_timeout() -> void:
	queue_free()
