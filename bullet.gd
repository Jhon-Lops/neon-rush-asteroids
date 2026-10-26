extends Area2D

@export var speed: float = 700.0

func _ready() -> void:
	add_to_group("bullets")

func _process(delta: float) -> void:
	position.y -= speed * delta

	if position.y < -50.0:
		queue_free()
