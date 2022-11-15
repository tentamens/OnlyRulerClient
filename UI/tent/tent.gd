extends TouchScreenButton

onready var close_popup = get_parent().get_node("TentPopUpCanvas/ClosePopUp")



func _on_tent_pressed():
	print("pressed")
	get_parent().get_node("TentPopUpCanvas/TentPopUp").popup()
	close_popup.disabled = false
	close_popup.visible = true



func _on_ClosePopUp_button_down():
	close_popup.disabled = true
	get_parent().get_node("TentPopUpCanvas/TentPopUp").popup()
	close_popup.visible = false
