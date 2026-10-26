extends Control

signal movement_changed(direction: Vector2)
signal shoot_changed(pressed: bool)

@export var enabled_on_desktop := false

var movement := Vector2.ZERO
var shooting := false
var joystick_touch_id := -1
var shoot_touch_id := -1
var joystick_center := Vector2.ZERO
var joystick_knob := Vector2.ZERO
var joystick_radius := 86.0
var shoot_center := Vector2.ZERO
var shoot_radius := 66.0

func _ready() -> void:
	set_process_input(true)
	_update_layout()
	visible = enabled_on_desktop or DisplayServer.is_touchscreen_available() or OS.has_feature("mobile")
	queue_redraw()

func _notification(what: int) -> void:
	if what == NOTIFICATION_RESIZED:
		_update_layout()
		queue_redraw()

func _update_layout() -> void:
	var size := get_viewport_rect().size
	var scale_factor := clampf(minf(size.x / 960.0, size.y / 540.0), 0.75, 1.5)
	joystick_radius = 86.0 * scale_factor
	shoot_radius = 66.0 * scale_factor
	joystick_center = Vector2(118.0 * scale_factor, size.y - 112.0 * scale_factor)
	shoot_center = Vector2(size.x - 112.0 * scale_factor, size.y - 112.0 * scale_factor)
	joystick_knob = joystick_center + movement * joystick_radius * 0.65

func _input(event: InputEvent) -> void:
	if not visible:
		return

	if event is InputEventScreenTouch:
		var touch := event as InputEventScreenTouch
		if touch.pressed:
			if joystick_touch_id == -1 and touch.position.distance_to(joystick_center) <= joystick_radius * 1.35:
				joystick_touch_id = touch.index
				_update_joystick(touch.position)
				get_viewport().set_input_as_handled()
			elif shoot_touch_id == -1 and touch.position.distance_to(shoot_center) <= shoot_radius * 1.25:
				shoot_touch_id = touch.index
				_set_shooting(true)
				get_viewport().set_input_as_handled()
		else:
			if touch.index == joystick_touch_id:
				joystick_touch_id = -1
				_set_movement(Vector2.ZERO)
				get_viewport().set_input_as_handled()
			elif touch.index == shoot_touch_id:
				shoot_touch_id = -1
				_set_shooting(false)
				get_viewport().set_input_as_handled()

	elif event is InputEventScreenDrag:
		var drag := event as InputEventScreenDrag
		if drag.index == joystick_touch_id:
			_update_joystick(drag.position)
			get_viewport().set_input_as_handled()

func _update_joystick(position: Vector2) -> void:
	var offset := position - joystick_center
	if offset.length() > joystick_radius:
		offset = offset.normalized() * joystick_radius
	_set_movement(offset / joystick_radius)

func _set_movement(direction: Vector2) -> void:
	movement = direction.limit_length(1.0)
	joystick_knob = joystick_center + movement * joystick_radius * 0.65
	movement_changed.emit(movement)
	queue_redraw()

func _set_shooting(pressed: bool) -> void:
	if shooting == pressed:
		return
	shooting = pressed
	shoot_changed.emit(shooting)
	queue_redraw()

func _draw() -> void:
	var base_color := Color(0.12, 0.82, 1.0, 0.22)
	var outline_color := Color(0.35, 0.95, 1.0, 0.8)
	var knob_color := Color(0.7, 0.25, 1.0, 0.72)
	var shoot_color := Color(1.0, 0.25, 0.7, 0.72) if shooting else Color(1.0, 0.25, 0.7, 0.45)

	draw_circle(joystick_center, joystick_radius, base_color)
	draw_arc(joystick_center, joystick_radius, 0.0, TAU, 48, outline_color, 3.0)
	draw_circle(joystick_knob, joystick_radius * 0.38, knob_color)
	draw_arc(joystick_knob, joystick_radius * 0.38, 0.0, TAU, 32, Color(0.9, 0.8, 1.0, 0.85), 2.0)

	draw_circle(shoot_center, shoot_radius, shoot_color)
	draw_arc(shoot_center, shoot_radius, 0.0, TAU, 48, Color(1.0, 0.6, 0.9, 0.9), 3.0)
	draw_string(ThemeDB.fallback_font, shoot_center - Vector2(22.0, -9.0), "FIRE", HORIZONTAL_ALIGNMENT_LEFT, -1.0, 18, Color.WHITE)
