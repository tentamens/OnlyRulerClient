extends TextureButton


var touch_pos




func _input(event):
	if event is InputEventScreenTouch:
		touch_pos = get_canvas_transform().affine_inverse().xform(event.position)
	if event is InputEventScreenDrag:
		touch_pos = get_canvas_transform().affine_inverse().xform(event.position)
