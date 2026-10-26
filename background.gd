extends Node2D

@export var scroll_speed: float = 120.0
@export var screen_height: float = 540.0

func _process(delta: float) -> void:
	$BackgroundA.position.y += scroll_speed * delta
	$BackgroundB.position.y += scroll_speed * delta

	if $BackgroundA.position.y >= screen_height + screen_height / 2.0:
		$BackgroundA.position.y = $BackgroundB.position.y - screen_height

	if $BackgroundB.position.y >= screen_height + screen_height / 2.0:
		$BackgroundB.position.y = $BackgroundA.position.y - screen_height
