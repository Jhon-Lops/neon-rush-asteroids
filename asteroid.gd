extends Area2D

@export var speed: float = 150.0
@export var rotation_speed: float = 2.0
@export var smoke_scene: PackedScene

var destroyed := false
var horizontal_speed: float
var wobble_amount: float
var wobble_speed: float
var wobble_time: float
var screen_size: Vector2

func _ready() -> void:
	add_to_group("asteroids")

	screen_size = get_viewport_rect().size

	var asteroid_size := randf_range(0.55, 1.35)
	scale = Vector2.ONE * asteroid_size

	speed = randf_range(100.0, 240.0)
	horizontal_speed = randf_range(-90.0, 90.0)
	rotation_speed = randf_range(-3.0, 3.0)

	wobble_amount = randf_range(10.0, 35.0)
	wobble_speed = randf_range(1.0, 3.0)
	wobble_time = randf_range(0.0, 10.0)

	area_entered.connect(_on_area_entered)
	body_entered.connect(_on_body_entered)


func _process(delta: float) -> void:
	wobble_time += delta * wobble_speed

	position.y += speed * delta
	position.x += horizontal_speed * delta
	position.x += sin(wobble_time) * wobble_amount * delta

	rotation += rotation_speed * delta

	if position.x < 30.0 or position.x > screen_size.x - 30.0:
		horizontal_speed *= -1.0

	if position.y > screen_size.y + 100.0:
		queue_free()


func _on_area_entered(area: Area2D) -> void:
	if destroyed:
		return

	if area.is_in_group("bullets"):
		area.call_deferred("queue_free")
		call_deferred("_destroy_asteroid_deferred")

func _on_body_entered(body: Node2D) -> void:
	if destroyed:
		return

	if body.is_in_group("player"):
		destroyed = true
		get_tree().current_scene.call_deferred("game_over")
		call_deferred("queue_free")

func _destroy_asteroid_deferred() -> void:
	if destroyed:
		return

	destroyed = true

	var explosion_position: Vector2 = global_position

	if smoke_scene == null:
		push_warning("Smoke Scene não foi vinculada ao Asteroid.")
	else:
		var smoke := smoke_scene.instantiate()
		get_tree().current_scene.add_child(smoke)
		smoke.global_position = explosion_position

	queue_free()
