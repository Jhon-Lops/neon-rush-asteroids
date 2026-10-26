extends CharacterBody2D

@export var speed: float = 300.0
@export var bullet_scene: PackedScene
@export var fire_cooldown: float = 0.2
@export var ship_margin: float = 48.0

var can_fire := true
var mobile_movement := Vector2.ZERO
var mobile_shooting := false

@onready var mobile_controls: Control = get_node_or_null("../MobileControls") as Control

func _physics_process(_delta: float) -> void:
	var direction := Input.get_vector(
		"ui_left",
		"ui_right",
		"ui_up",
        "ui_down"
	)
	direction += mobile_movement

	if Input.is_key_pressed(KEY_A):
		direction.x -= 1.0

	if Input.is_key_pressed(KEY_D):
		direction.x += 1.0

	if Input.is_key_pressed(KEY_W):
		direction.y -= 1.0

	if Input.is_key_pressed(KEY_S):
		direction.y += 1.0

	if direction.length() > 1.0:
		direction = direction.normalized()

	velocity = direction * speed
	move_and_slide()

	keep_ship_inside_screen()

	if (Input.is_key_pressed(KEY_SPACE) or mobile_shooting) and can_fire:
		fire()

func _ready() -> void:
	if mobile_controls == null:
		return
	mobile_controls.movement_changed.connect(_on_mobile_movement_changed)
	mobile_controls.shoot_changed.connect(_on_mobile_shoot_changed)

func _on_mobile_movement_changed(direction: Vector2) -> void:
	mobile_movement = direction

func _on_mobile_shoot_changed(pressed: bool) -> void:
	mobile_shooting = pressed


func keep_ship_inside_screen() -> void:
	var screen_size := get_viewport_rect().size

	global_position.x = clamp(
		global_position.x,
		ship_margin,
		screen_size.x - ship_margin
	)

	global_position.y = clamp(
		global_position.y,
		ship_margin,
		screen_size.y - ship_margin
	)


func fire() -> void:
	if bullet_scene == null:
		push_warning("Bullet Scene não foi vinculada à nave.")
		return

	var muzzle := get_node_or_null("Muzzle")

	if muzzle == null:
		push_warning("Adicione um Marker2D chamado Muzzle dentro de Ship.")
		return

	can_fire = false

	var bullet := bullet_scene.instantiate()
	get_tree().current_scene.add_child(bullet)

	bullet.global_position = muzzle.global_position

	await get_tree().create_timer(fire_cooldown).timeout
	can_fire = true
