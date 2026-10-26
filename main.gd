extends Node2D

@export var asteroid_scene: PackedScene

@onready var asteroid_timer: Timer = $AsteroidTimer
@onready var pause_panel: Control = $PausePanel
@onready var game_over_panel: Control = $GameOverPanel
@onready var time_label: Label = $HUD/TimeLabel
@onready var game_over_duration: Label = $GameOverPanel/GameOverContent/Duration
@onready var locale_manager: Node = get_node("/root/Locale")

var is_paused := false
var game_over_active := false
var elapsed_time := 0.0
var asteroid_wave := 0

func _ready() -> void:
	randomize()
	asteroid_timer.timeout.connect(_on_asteroid_timer_timeout)
	$Music.finished.connect(_on_music_finished)
	pause_panel.visible = false
	game_over_panel.visible = false
	_apply_language()

func _apply_language() -> void:
	time_label.text = locale_manager.translate("time") + "  00:00"
	$PausePanel/Panel/Title.text = locale_manager.translate("paused")
	$PausePanel/Panel/ContinueButton.text = locale_manager.translate("continue")
	$PausePanel/Panel/MenuButton.text = locale_manager.translate("menu")
	$PausePanel/Panel/QuitButton.text = locale_manager.translate("quit")
	$GameOverPanel/GameOverContent/Title.text = locale_manager.translate("game_over")
	$GameOverPanel/GameOverContent/Message.text = locale_manager.translate("destroyed")
	$GameOverPanel/GameOverContent/RestartButton.text = locale_manager.translate("restart")
	$GameOverPanel/GameOverContent/MenuButton.text = locale_manager.translate("menu")

func _process(delta: float) -> void:
	if game_over_active or get_tree().paused:
		return

	elapsed_time += delta
	time_label.text = locale_manager.translate("time") + "  " + _format_time(elapsed_time)

func _format_time(total_seconds: float) -> String:
	var seconds := int(total_seconds)
	var minutes := seconds / 60
	var remaining_seconds := seconds % 60
	return "%02d:%02d" % [minutes, remaining_seconds]

func _on_music_finished() -> void:
	$Music.play()

func _unhandled_input(event: InputEvent) -> void:
	if game_over_active:
		return

	if event.is_action_pressed("ui_cancel"):
		toggle_pause()

func toggle_pause() -> void:
	if game_over_active:
		return

	is_paused = not is_paused
	get_tree().paused = is_paused
	pause_panel.visible = is_paused

	if is_paused:
		$PausePanel/Panel/ContinueButton.grab_focus()

func _on_continue_button_pressed() -> void:
	toggle_pause()

func _on_menu_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://MainMenu.tscn")

func _on_quit_button_pressed() -> void:
	get_tree().quit()

func game_over() -> void:
	if game_over_active:
		return

	game_over_active = true
	$AsteroidTimer.stop()

	var ship: CharacterBody2D = get_node_or_null("Ship") as CharacterBody2D
	if ship != null:
		var smoke_scene: PackedScene = load("res://smoke.tscn")
		var smoke: Node2D = smoke_scene.instantiate() as Node2D
		add_child(smoke)
		smoke.global_position = ship.global_position
		ship.visible = false
		ship.set_physics_process(false)

	for asteroid in get_tree().get_nodes_in_group("asteroids"):
		asteroid.queue_free()

	game_over_panel.visible = true
	game_over_duration.text = locale_manager.translate("survived") % _format_time(elapsed_time)
	$GameOverPanel/GameOverContent/RestartButton.grab_focus()

func _on_restart_button_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_game_over_menu_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://MainMenu.tscn")


func _on_asteroid_timer_timeout() -> void:
	if asteroid_scene == null:
		push_warning("Asteroid Scene não foi vinculada ao Main.")
		return

	asteroid_wave += 1
	var amount: int = mini(1 + int(elapsed_time / 20.0), 6)

	for i in range(amount):
		spawn_asteroid()

	var next_wait: float = maxf(0.25, 0.9 - elapsed_time / 90.0)
	asteroid_timer.wait_time = next_wait


func spawn_asteroid() -> void:
	var asteroid: Area2D = asteroid_scene.instantiate() as Area2D
	add_child(asteroid)

	var screen_width := get_viewport_rect().size.x

	asteroid.position = Vector2(
		randf_range(40.0, screen_width - 40.0),
		-80.0
	)
