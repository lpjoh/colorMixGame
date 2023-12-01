extends Node

signal swiped(direction)
signal swipe_canceled(start_position)
signal tapped()

export(float, 1.0, 1.5) var MAX_DIAGONAL_SLOPE = 1.3
onready var timer = $Timer
var swipe_start_position = Vector2()

func _input(event):
	if not event is InputEventMouseButton:
		return
	if event.is_pressed():
		_start_detection(event.position)
	elif not timer.is_stopped():
		_end_detection(event.position)

func _start_detection(position):
	swipe_start_position = position
	timer.start()

func _end_detection(position):
	timer.stop()
	var direction = (position - swipe_start_position).normalized()
	if abs(position.x - swipe_start_position.x) > 5 or abs(position.y - swipe_start_position.y) > 5:
		if abs(direction.x) > abs(direction.y):
			emit_signal("swiped", Vector2(-sign(direction.x), 0.0))
		else:
			emit_signal("swiped", Vector2(0.0, -sign(direction.y)))
	else:
		emit_signal("tapped")
	print((position - swipe_start_position))

func _on_Timer_timeout():
	emit_signal("swipe_canceled", swipe_start_position)
