extends Node2D

const MINIMUM_SWIPE = 32

signal swiped(start_position, direction)
var swipe_start_position = Vector2()

func _unhandled_input(event):
	if (event.is_action_pressed('ui_select') or event is InputEventScreenTouch):
		_start_detection(event.position)
	if event.is_action_released('ui_select') and swipe_start_position.length() > 0:
		_end_detection(event.position)

func _start_detection(position):
	swipe_start_position = position

func _end_detection(position):
	var distance = position - swipe_start_position
	if abs(distance.x) >= MINIMUM_SWIPE or abs(distance.y) >= MINIMUM_SWIPE:
		var direction: Vector2 = (distance).normalized()
		
		if abs(direction.x) > abs(direction.y):
			direction = Vector2(sign(direction.x), 0.0)
		else:
			direction = Vector2(0.0, sign(direction.y))
			
		emit_signal('swiped', swipe_start_position, direction)
	swipe_start_position = Vector2()
