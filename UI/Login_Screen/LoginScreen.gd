extends CanvasLayer


onready var username_input = get_node("VBoxContainer/Username_lineEdit")
onready var password_input = get_node("VBoxContainer/password_lineEdit")
onready var login_button = get_node("VBoxContainer/LoginButton")




func _on_LoginButton_pressed():
	if username_input.get_text() == "" or password_input.get_text() == "":
		# Make Popup for this
		print("Please provide a valid username and password")

	else:
		login_button.disabled = true
		var username = username_input.get_text()
		var password = password_input.get_text()
		print("Attempting to login")
		Gateway.ConnectToServer(username, password)
