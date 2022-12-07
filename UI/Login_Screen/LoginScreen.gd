extends CanvasLayer


onready var username_input = get_node("LoginIn/Username_lineEdit")
onready var password_input = get_node("LoginIn/password_lineEdit")
onready var login_button = get_node("LoginIn/LoginButton")
# Create account nodes
onready var create_username_input = get_node("CreateAccount/Email_Address_lineEdit")
onready var create_userpassword_input = get_node("CreateAccount/password_lineEdit")
onready var create_userpassword_repeat_input = get_node("CreateAccount/RPpassword_lineEdit")
onready var confirm_button = get_node("CreateAccount/Confirm_Button")
onready var back_button = get_node("CreateAccount/Back_button")


func _on_LoginButton_pressed():
	if username_input.get_text() == "" or password_input.get_text() == "":
		# Make Popup for this
		print("Please provide a valid username and password")

	else:
		login_button.disabled = true
		var username = username_input.get_text()
		var password = password_input.get_text()
		print("Attempting to login")
		Gateway.ConnectToServer(username, password, false)


func _on_Confirm_Button_pressed():
	if create_username_input.get_text() == "":
		print("Please provide a valid username")
	
	elif create_userpassword_input.get_text() == "":
		print("Please provid a valid password")
	
	elif create_userpassword_repeat_input.get_text() == "":
		print("Please repeat your password")
	
	elif create_userpassword_input.get_text() != create_userpassword_repeat_input.get_text():
		print("Passwords don't match")
	
	elif create_userpassword_input.get_text().length() <= 6:
		print("Password must be at least 7 characters")
	else:
		confirm_button.disabled = true
		back_button.disabled = true
		var username = create_username_input.get_text()
		var password = create_userpassword_input.get_text()
		Gateway.ConnectToServer(username, password, true)


func _on_Back_button_pressed():
	get_node("CreateAccount").hide()
	get_node("LoginIn").show()


func _on_Create_account_pressed():
	get_node("CreateAccount").show()
	get_node("LoginIn").hide()
