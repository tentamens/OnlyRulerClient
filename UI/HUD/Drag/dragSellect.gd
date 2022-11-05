extends Node2D

var touch = false

var dragging = false
var selected = []
var drag_start = Vector2.ZERO
var selected_rect = RectangleShape2D.new()
var drag_pos


func _unhandled_input(event):
	if event is InputEventScreenTouch:
		print("pressed")
		if selected.size() == 0:
			dragging = true
			drag_start = event.position
		elif dragging:
			dragging = false
	if event is InputEventScreenDrag and dragging:
		update()
		print("print")
		drag_pos = event.position

func _draw():
	if dragging:
		draw_rect(Rect2(drag_start, drag_pos - drag_start),
		Color(0.5, 0.5, 0.5), false)
	






